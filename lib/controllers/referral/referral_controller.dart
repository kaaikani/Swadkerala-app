import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../graphql/referral.graphql.dart';

import '../../services/graphql_client.dart';
import '../base_controller.dart';

class ReferralController extends BaseController {
  final RxBool hasRedeemed = false.obs;

  /// Load redeemed status from local cache (keyed by customer ID).
  void loadRedeemedStatus(String customerId) {
    hasRedeemed.value = GetStorage().read<bool>('referral_redeemed_$customerId') ?? false;
  }

  /// Mark referral as redeemed and persist (keyed by customer ID).
  void _markRedeemed(String customerId) {
    hasRedeemed.value = true;
    GetStorage().write('referral_redeemed_$customerId', true);
  }

  final RxList<Query$MyReferrals$myReferrals$items> referrals =
      <Query$MyReferrals$myReferrals$items>[].obs;
  final RxList<Query$EarnedScratchCards$earnedScratchCards$items> earnedCards =
      <Query$EarnedScratchCards$earnedScratchCards$items>[].obs;
  final RxList<Query$ScratchedCards$scratchedCards$items> scratchedCardsList =
      <Query$ScratchedCards$scratchedCards$items>[].obs;
  final RxInt totalReferrals = 0.obs;
  final RxInt totalEarnedCards = 0.obs;
  final RxInt totalScratchedCards = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isScratchLoading = false.obs;
  final RxInt channelPoints = 0.obs;

  /// Fetch all cards (earned + scratched) combined
  Future<void> fetchAllCards() async {
    isLoading.value = true;
    try {
      await Future.wait([
        fetchEarnedScratchCards(),
        fetchScratchedCards(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// Pending referrer ID from deep link (to register after login)
  static String? pendingReferrerId;

  /// Fetch all referrals for the current customer
  Future<void> fetchMyReferrals({int take = 50, int skip = 0}) async {
    isLoading.value = true;
    try {
      final response = await GraphqlService.client.value.query$MyReferrals(
        Options$Query$MyReferrals(
          variables: Variables$Query$MyReferrals(take: take, skip: skip),
        ),
      );
      if (checkResponseForErrors(response)) return;
      final data = response.parsedData?.myReferrals;
      if (data != null) {
        referrals.assignAll(data.items);
        totalReferrals.value = data.totalItems;
      }
    } catch (e) {
      // debugPrint('Error fetching referrals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch earned (eligible, unscratched) scratch cards
  Future<void> fetchEarnedScratchCards({int take = 50, int skip = 0}) async {
    isLoading.value = true;
    try {
      final response =
          await GraphqlService.client.value.query$EarnedScratchCards(
        Options$Query$EarnedScratchCards(
          variables: Variables$Query$EarnedScratchCards(take: take, skip: skip),
        ),
      );
      if (checkResponseForErrors(response)) return;
      final data = response.parsedData?.earnedScratchCards;
      if (data != null) {
        earnedCards.assignAll(data.items);
        totalEarnedCards.value = data.totalItems;
      }
    } catch (e) {
      // debugPrint('Error fetching earned cards: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch scratched (claimed) cards
  Future<void> fetchScratchedCards({int take = 50, int skip = 0}) async {
    try {
      final response = await GraphqlService.client.value.query$ScratchedCards(
        Options$Query$ScratchedCards(
          variables: Variables$Query$ScratchedCards(take: take, skip: skip),
        ),
      );
      if (checkResponseForErrors(response)) return;
      final data = response.parsedData?.scratchedCards;
      if (data != null) {
        scratchedCardsList.assignAll(data.items);
        totalScratchedCards.value = data.totalItems;
      }
    } catch (e) {
      // debugPrint('Error fetching scratched cards: $e');
    }
  }

  /// Fetch channel-wise referral points config
  Future<void> fetchChannelPoints() async {
    try {
      final response =
          await GraphqlService.client.value.query$ReferralChannelPoints(
        Options$Query$ReferralChannelPoints(),
      );
      if (checkResponseForErrors(response)) return;
      final data = response.parsedData?.referralChannelPoints;
      if (data != null) {
        channelPoints.value = data.points;
      }
    } catch (e) {
      // debugPrint('Error fetching channel points: $e');
    }
  }

  /// Register a referral (called when new user opens app via referral link)
  Future<bool> registerReferral(String referrerId, {String? customerId}) async {
    try {
      final response =
          await GraphqlService.client.value.mutate$RegisterReferral(
        Options$Mutation$RegisterReferral(
          variables: Variables$Mutation$RegisterReferral(
            referrerId: referrerId,
          ),
        ),
      );
      if (response.hasException) {
        final errorMsg = response.exception?.graphqlErrors.firstOrNull?.message ?? 'Unknown error';
        // debugPrint('Referral registration error: $errorMsg');
        return false;
      }
      if (customerId != null) _markRedeemed(customerId);
      return true;
    } catch (e) {
      // debugPrint('Error registering referral: $e');
      return false;
    }
  }

  /// Scratch a referral card by referralNumber
  Future<Mutation$ScratchReferralCard$scratchReferralCard?> scratchCard(
      int referralNumber) async {
    isScratchLoading.value = true;
    try {
      final response =
          await GraphqlService.client.value.mutate$ScratchReferralCard(
        Options$Mutation$ScratchReferralCard(
          variables: Variables$Mutation$ScratchReferralCard(
            referralNumber: referralNumber,
          ),
        ),
      );
      if (response.hasException) {
        final errorMsg = response.exception?.graphqlErrors.firstOrNull?.message ??
            'Failed to scratch card';
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 3),
        );
        return null;
      }
      final result = response.parsedData?.scratchReferralCard;
      if (result != null) {
        await Future.wait([
          fetchEarnedScratchCards(),
          fetchScratchedCards(),
          fetchMyReferrals(),
        ]);
        return result;
      }
      return null;
    } catch (e) {
      // debugPrint('Error scratching card: $e');
      return null;
    } finally {
      isScratchLoading.value = false;
    }
  }

  /// Process pending referral after login
  Future<void> processPendingReferral() async {
    if (pendingReferrerId != null && pendingReferrerId!.isNotEmpty) {
      final id = pendingReferrerId!;
      pendingReferrerId = null;
      await registerReferral(id);
    }
  }
}
