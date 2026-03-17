import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratcher/scratcher.dart';
import '../controllers/referral/referral_controller.dart';
import '../graphql/referral.graphql.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../services/analytics_service.dart';

class ScratchCardsPage extends StatefulWidget {
  const ScratchCardsPage({super.key});

  @override
  State<ScratchCardsPage> createState() => _ScratchCardsPageState();
}

class _ScratchCardsPageState extends State<ScratchCardsPage> {
  final ReferralController referralController = Get.find<ReferralController>();

  @override
  void initState() {
    super.initState();
    AnalyticsService().logScreenView(screenName: 'ScratchCards');
    referralController.fetchAllCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Rewards',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(20),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        surfaceTintColor: Colors.transparent,
      ),
      body: Obx(() {
        if (referralController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final earned = referralController.earnedCards;
        final scratched = referralController.scratchedCardsList;
        if (earned.isEmpty && scratched.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.card_giftcard_outlined,
                  size: ResponsiveUtils.rp(64),
                  color: AppColors.iconLight,
                ),
                SizedBox(height: ResponsiveUtils.rp(16)),
                Text(
                  'No rewards yet',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.rp(8)),
                Text(
                  'Refer friends to earn scratch cards!',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }
        final totalCount = earned.length + scratched.length;
        return RefreshIndicator(
          onRefresh: () => referralController.fetchAllCards(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;
              final crossAxisCount = isLandscape ? 4 : 2;
              final spacing = ResponsiveUtils.rp(12);
              return GridView.builder(
                padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: 0.85,
                ),
                itemCount: totalCount,
                itemBuilder: (context, index) {
                  if (index < earned.length) {
                    final card = earned[index];
                    return _EarnedCardTile(
                      card: card,
                      onTap: () => _showScratchDialog(card),
                    );
                  } else {
                    final card = scratched[index - earned.length];
                    return _ScratchedCardTile(card: card);
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }

  void _showScratchDialog(Query$EarnedScratchCards$earnedScratchCards$items card) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ScratchCardDialog(
        card: card,
        referralController: referralController,
      ),
    );
  }
}

/// GPay-style unscratched card — white card, golden circle, tap to scratch
class _EarnedCardTile extends StatelessWidget {
  final Query$EarnedScratchCards$earnedScratchCards$items card;
  final VoidCallback onTap;

  const _EarnedCardTile({required this.card, required this.onTap});

  String get _referredName {
    final name = '${card.referredCustomer.firstName} ${card.referredCustomer.lastName}'.trim();
    return name.isNotEmpty ? name : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Golden circle with gift icon
            Container(
              width: ResponsiveUtils.rp(60),
              height: ResponsiveUtils.rp(60),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFFD54F), const Color(0xFFFFA726)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA726).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Icons.card_giftcard,
                color: Colors.white,
                size: ResponsiveUtils.rp(28),
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(12)),
            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
              child: Text(
                _referredName,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(4)),
            Text(
              'Tap to scratch',
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: const Color(0xFFFFA726),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// GPay-style scratched card — white card, green circle with check, points shown
class _ScratchedCardTile extends StatelessWidget {
  final Query$ScratchedCards$scratchedCards$items card;

  const _ScratchedCardTile({required this.card});

  String get _referredName {
    final name = '${card.referredCustomer.firstName} ${card.referredCustomer.lastName}'.trim();
    return name.isNotEmpty ? name : 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Green circle with check
          Container(
            width: ResponsiveUtils.rp(60),
            height: ResponsiveUtils.rp(60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF66BB6A), const Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF43A047).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: ResponsiveUtils.rp(30),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(10)),
          // Points
          Text(
            '+${card.points}',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(22),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF43A047),
            ),
          ),
          Text(
            'points',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(12),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(4)),
          // Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(10)),
            child: Text(
              _referredName,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(12),
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// GPay-style scratch dialog — clean white reveal, golden scratch surface
class _ScratchCardDialog extends StatefulWidget {
  final Query$EarnedScratchCards$earnedScratchCards$items card;
  final ReferralController referralController;

  const _ScratchCardDialog({
    required this.card,
    required this.referralController,
  });

  @override
  State<_ScratchCardDialog> createState() => _ScratchCardDialogState();
}

class _ScratchCardDialogState extends State<_ScratchCardDialog>
    with SingleTickerProviderStateMixin {
  bool _isRevealed = false;
  bool _apiCalled = false;
  Mutation$ScratchReferralCard$scratchReferralCard? _result;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  final _scratchKey = GlobalKey<ScratcherState>();

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _onScratchComplete() async {
    if (_apiCalled) return;
    _apiCalled = true;
    final result = await widget.referralController.scratchCard(
      widget.card.referralNumber,
    );
    if (result != null) {
      setState(() {
        _result = result;
        _isRevealed = true;
      });
      _scratchKey.currentState?.reveal(duration: const Duration(milliseconds: 400));
      _scaleController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveUtils.rp(300).toDouble();
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(ResponsiveUtils.rp(32)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ResponsiveUtils.rp(24)),
              child: SizedBox(
                width: size,
                height: size,
                child: Scratcher(
                  key: _scratchKey,
                  brushSize: 50,
                  threshold: 40,
                  color: const Color(0xFFFFD54F),
                  image: Image(
                    image: AssetImage('assets/images/kklogo_padded.png'),
                    fit: BoxFit.cover,
                    color: const Color(0xFFFFA726).withValues(alpha: 0.2),
                    colorBlendMode: BlendMode.srcATop,
                  ),
                  onChange: (value) {
                    if (value > 40 && !_apiCalled) {
                      _onScratchComplete();
                    }
                  },
                  onThreshold: () {
                    if (!_apiCalled) {
                      _onScratchComplete();
                    }
                  },
                  child: Container(
                    width: size,
                    height: size,
                    color: Colors.white,
                    child: _result != null
                        ? ScaleTransition(
                            scale: _scaleAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: ResponsiveUtils.rp(72),
                                  height: ResponsiveUtils.rp(72),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [const Color(0xFF66BB6A), const Color(0xFF43A047)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: ResponsiveUtils.rp(40),
                                  ),
                                ),
                                SizedBox(height: ResponsiveUtils.rp(16)),
                                Text(
                                  'You won',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(16),
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: ResponsiveUtils.rp(4)),
                                Text(
                                  '${_result!.points}',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(48),
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF43A047),
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  'Points',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(16),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF43A047),
                                  ),
                                ),
                                SizedBox(height: ResponsiveUtils.rp(12)),
                                Text(
                                  'Added to your wallet',
                                  style: TextStyle(
                                    fontSize: ResponsiveUtils.sp(13),
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app_outlined,
                                size: ResponsiveUtils.rp(40),
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: ResponsiveUtils.rp(8)),
                              Text(
                                'Scratch above to reveal',
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(14),
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(24)),
          // Buttons
          if (_isRevealed)
            SizedBox(
              width: ResponsiveUtils.rp(200).toDouble(),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF43A047),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveUtils.rp(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(28)),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (!_isRevealed)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtils.rp(24),
                  vertical: ResponsiveUtils.rp(10),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: ResponsiveUtils.sp(15)),
              ),
            ),
        ],
      ),
    );
  }
}
