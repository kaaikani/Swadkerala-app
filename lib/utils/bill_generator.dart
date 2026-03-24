import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' show Rect;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../graphql/order.graphql.dart';
import '../services/channel_service.dart';
import '../controllers/banner/bannercontroller.dart';
import '../widgets/loading_dialog.dart';
import 'price_formatter.dart';

class BillGenerator {
  /// Sanitize string for PDF to avoid FormatException (Unfinished UTF-8 octet sequence).
  static String _safeString(String? s) {
    if (s == null || s.isEmpty) return '';
    try {
      return utf8.decode(utf8.encode(s), allowMalformed: true);
    } catch (_) {
      return s.replaceAll(RegExp(r'[^\x20-\x7E\u00A0-\u024F\u0400-\u04FF]'), '?');
    }
  }

  /// Format price for PDF with rupee symbol
  /// Converts paise to rupees and adds ₹ symbol
  static String formatPriceForPdf(int priceInPaise) {
    final amount = priceInPaise / 100;
    final bool isWholeNumber = (amount % 1).abs() < 0.0001;
    final String value =
        isWholeNumber ? PriceFormatter.addCommas(amount.toInt().toString()) : PriceFormatter.addCommas(amount.toStringAsFixed(2));
    return 'Rs. $value';
  }

  /// Format price for PDF from double (already in rupees)
  static String formatPriceForPdfFromDouble(double priceInRupees) {
    final bool isWholeNumber = (priceInRupees % 1).abs() < 0.0001;
    final String value =
        isWholeNumber ? PriceFormatter.addCommas(priceInRupees.toInt().toString()) : PriceFormatter.addCommas(priceInRupees.toStringAsFixed(2));
    return 'Rs. $value';
  }
  /// [sharePositionOrigin] Optional rect for iOS/iPadOS share sheet popover.
  /// Required on iOS 26+ (must be non-zero). Callers can pass e.g. the share button bounds.
  static Future<void> generateAndShare(Fragment$Cart order, {Rect? sharePositionOrigin}) async {
    try {
      await _generateAndShareImpl(order, sharePositionOrigin);
    } catch (e) {
      LoadingDialog.hide();
      rethrow;
    }
  }

  static Future<void> _generateAndShareImpl(Fragment$Cart order, Rect? sharePositionOrigin) async {
    // Pre-load logo image asynchronously to avoid blocking
    final channelType = ChannelService.getChannelType() ?? '';
    final isCityChannel = channelType.contains('CITY');
    pw.Image? logoImage;

    // Load image in parallel with other setup (non-blocking)
    if (isCityChannel) {
      try {
        // Try primary path first
        final imageData = await rootBundle.load('assets/images/city_logo.png').timeout(
          const Duration(milliseconds: 500),
          onTimeout: () => throw TimeoutException('Image load timeout'),
        );
        final imageBytes = imageData.buffer.asUint8List();
        logoImage = pw.Image(
          pw.MemoryImage(imageBytes),
          width: 100,
          height: 50,
          fit: pw.BoxFit.contain,
        );
      } catch (_) {
        // Try fallback path with timeout
        try {
          final imageData = await rootBundle.load('assets/images/kklogo.png').timeout(
            const Duration(milliseconds: 500),
            onTimeout: () => throw TimeoutException('Image load timeout'),
          );
          final imageBytes = imageData.buffer.asUint8List();
          logoImage = pw.Image(
            pw.MemoryImage(imageBytes),
            width: 100,
            height: 50,
            fit: pw.BoxFit.contain,
          );
        } catch (e) {
          // Image not found or timeout, will use text instead
          logoImage = null;
        }
      }
    }

    // Fetch loyalty points config only if not already loaded (avoids slow network call every share).
    // Timeout after 3 seconds to avoid hanging the loading dialog indefinitely.
    if (Get.isRegistered<BannerController>()) {
      final bannerController = Get.find<BannerController>();
      if (bannerController.loyaltyPointsConfig.value == null) {
        try {
          await bannerController.fetchLoyaltyPointsConfig().timeout(
            const Duration(seconds: 3),
            onTimeout: () {}, // Skip if network is slow
          );
        } catch (_) {}
      }
    }
    final loyaltyConfig = Get.isRegistered<BannerController>()
        ? Get.find<BannerController>().loyaltyPointsConfig.value
        : null;

    // Use Unicode-capable fonts when possible. On some platforms (e.g. iOS) loading TTF can
    // cause FormatException (Unfinished UTF-8 at offset 4), so we try with theme first and
    // fall back to no theme so the invoice always generates.
    pw.ThemeData? pdfTheme;
    try {
      final baseData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
      final boldData = await rootBundle.load('assets/fonts/OpenSans-Bold.ttf');
      pdfTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(baseData),
        bold: pw.Font.ttf(boldData),
      );
    } catch (_) {
      pdfTheme = null;
    }

    Uint8List bytes;
    try {
      final pdf = pdfTheme != null
          ? pw.Document(theme: pdfTheme)
          : pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildHeader(order, logoImage),
              pw.SizedBox(height: 20),
              _buildInfoSection(order),
              pw.SizedBox(height: 20),
              _buildItemsTable(order),
              pw.SizedBox(height: 20),
              pw.Divider(),
              _buildTotalsSection(order, loyaltyConfig),
              pw.SizedBox(height: 40),
              _buildFooter(),
            ];
          },
        ),
      );
      bytes = await pdf.save();
    } on FormatException {
      // TTF/font can throw "Unfinished UTF-8 at offset 4" on some platforms (e.g. iOS). Retry without theme so the invoice still generates.
      final pdf = pw.Document();
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              _buildHeader(order, logoImage),
              pw.SizedBox(height: 20),
              _buildInfoSection(order),
              pw.SizedBox(height: 20),
              _buildItemsTable(order),
              pw.SizedBox(height: 20),
              pw.Divider(),
              _buildTotalsSection(order, loyaltyConfig),
              pw.SizedBox(height: 40),
              _buildFooter(),
            ];
          },
        ),
      );
      bytes = await pdf.save();
    }
    // Use app tmp only (never Cache). On iOS/Simulator, Cache causes "error fetching item for URL".
    Directory output;
    try {
      output = await getTemporaryDirectory();
    } catch (e) {
      output = Directory.systemTemp;
    }
    if (Platform.isIOS && output.path.toLowerCase().contains('caches')) {
      output = Directory.systemTemp;
    }
    final shareDir = Directory('${output.path}/kaaikani_share');
    if (!await shareDir.exists()) await shareDir.create(recursive: true);
    final file = File('${shareDir.path}/invoice_${order.code}.pdf');
    await file.writeAsBytes(bytes);

    final filePath = file.absolute.path;
    if (!await file.exists()) {
      throw Exception('PDF file was not written');
    }

    final origin = sharePositionOrigin ?? const Rect.fromLTWH(95, 372, 200, 100);

    // Hide loading BEFORE opening share sheet — otherwise the dialog blocks the share sheet
    // and can get stuck if the share sheet fails or is dismissed.
    LoadingDialog.hide();

    // On iOS, a short delay after writing ensures the file is visible to the share extension.
    if (Platform.isIOS) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }

    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Invoice - Order #${order.code}',
        sharePositionOrigin: origin,
      );
    } catch (e) {
      // Share sheet failed — don't rethrow, just show snackbar.
      // LoadingDialog is already hidden at this point.
      if (Get.isSnackbarOpen) Get.back();
      Get.snackbar('Share failed', 'Could not open share sheet. Try again.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  static pw.Widget _buildHeader(Fragment$Cart order, pw.Image? logoImage) {
    // Get channel name (sanitized for PDF UTF-8)
    final channelName = _safeString(ChannelService.getChannelName()?.toString() ?? 
        ChannelService.getChannelCode()?.toString() ?? 'Kaaikani');
    
    // Determine logo widget
    pw.Widget logoWidget;
    if (logoImage != null) {
      // Use the loaded image for city channel
      logoWidget = logoImage;
    } else {
      // Use channel name for other channels
      logoWidget = pw.Text(channelName,
          style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue600));
    }
    
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('INVOICE',
                style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 4),
            pw.Text('Order #${_safeString(order.code)}',
                style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700)),
          ],
        ),
        logoWidget,
      ],
    );
  }

  static pw.Widget _buildInfoSection(Fragment$Cart order) {
    // Access order as dynamic to get extended fields (Query$GetOrderByCode$orderByCode).
    // Fragment$Cart may not have these fields, so wrap each in try-catch to avoid crashes.
    final orderDynamic = order as dynamic;

    // Get customer information (sanitize for PDF to avoid FormatException)
    String firstName = '';
    String lastName = '';
    String emailAddress = '';
    try {
      final customer = orderDynamic.customer;
      firstName = _safeString(customer?.firstName ?? '');
      lastName = _safeString(customer?.lastName ?? '');
      final rawEmail = _safeString(customer?.emailAddress ?? '');
      emailAddress = rawEmail.trim().toLowerCase().endsWith('@kaikani.com')
          ? ''
          : rawEmail;
    } catch (_) {}

    // Get billing address (for phone number)
    String billingPhone = '';
    try {
      final billingAddress = orderDynamic.billingAddress;
      billingPhone = _safeString(billingAddress?.phoneNumber ?? '');
    } catch (_) {}

    // Get shipping address
    dynamic shippingAddress;
    try {
      shippingAddress = orderDynamic.shippingAddress;
    } catch (_) {
      shippingAddress = null;
    }

    // Get order date
    String orderDate;
    try {
      final orderPlacedAt = orderDynamic.orderPlacedAt;
      orderDate = orderPlacedAt != null
          ? DateTime.parse(orderPlacedAt.toString()).toString().split(' ')[0]
          : DateTime.now().toString().split(' ')[0];
    } catch (_) {
      orderDate = DateTime.now().toString().split(' ')[0];
    }

    // Get payment method
    String paymentMethodText = 'Offline Payment';
    try {
      final payments = orderDynamic.payments;
      String paymentMethod = 'N/A';
      if (payments != null && payments.isNotEmpty) {
        final payment = payments.first;
        paymentMethod = _safeString(payment.method ?? 'N/A');
      }
      final isOnlinePayment = paymentMethod.toLowerCase().contains('razorpay') ||
          paymentMethod.toLowerCase().contains('online') ||
          paymentMethod.toLowerCase().contains('card');
      paymentMethodText = isOnlinePayment ? 'Online Payment' : 'Offline Payment';
    } catch (_) {}
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            // Billed To section
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Billed To:',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                if (firstName.isNotEmpty || lastName.isNotEmpty)
                  pw.Text('${firstName} ${lastName}'.trim()),
                if (emailAddress.isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(emailAddress,
                      style: pw.TextStyle(fontSize: 10)),
                ],
                if (billingPhone.isNotEmpty) ...[
                  pw.SizedBox(height: 2),
                  pw.Text(billingPhone,
                      style: pw.TextStyle(fontSize: 10)),
                ],
              ],
            ),
            // Date and Payment section
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Date:',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.Text(orderDate),
                pw.SizedBox(height: 8),
                pw.Text('Payment:',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.Text(paymentMethodText),
              ],
            ),
          ],
        ),
        // Shipped To section
        if (shippingAddress != null) ...[
          pw.SizedBox(height: 16),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Shipped To:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              if (shippingAddress.fullName != null)
                pw.Text(_safeString(shippingAddress.fullName)),
              if (shippingAddress.streetLine1 != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(_safeString(shippingAddress.streetLine1),
                    style: pw.TextStyle(fontSize: 10)),
              ],
              if (shippingAddress.streetLine2 != null && shippingAddress.streetLine2.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(_safeString(shippingAddress.streetLine2),
                    style: pw.TextStyle(fontSize: 10)),
              ],
              pw.SizedBox(height: 2),
              pw.Text(
                _safeString([
                  if (shippingAddress.city != null) shippingAddress.city,
                  if (shippingAddress.province != null) shippingAddress.province,
                  if (shippingAddress.postalCode != null) shippingAddress.postalCode,
                ].where((e) => e != null && e.isNotEmpty).join(', ')),
                style: pw.TextStyle(fontSize: 10),
              ),
              if (shippingAddress.country != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  _safeString(shippingAddress.country.toString()),
                  style: pw.TextStyle(fontSize: 10),
                ),
              ],
              if (shippingAddress.phoneNumber != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(_safeString(shippingAddress.phoneNumber),
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ],
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildItemsTable(Fragment$Cart order) {
    final headers = ['Item', 'Qty', 'Price', 'Total'];
    final data = order.lines.map((line) {
      final isFree = line.discountedLinePriceWithTax == 0 || line.linePriceWithTax == 0;
      return [
        _safeString(line.productVariant.name),
        '${line.quantity}',
        isFree ? 'Free' : BillGenerator.formatPriceForPdf(line.unitPriceWithTax.toInt()),
        isFree ? 'Free' : BillGenerator.formatPriceForPdf(line.linePriceWithTax.toInt()),
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold),
      headerDecoration: pw.BoxDecoration(color: PdfColors.grey200),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildTotalsSection(
    Fragment$Cart order,
    dynamic loyaltyConfig,
  ) {
    // Total quantity from order lines
    final totalQuantity = order.lines.fold<int>(
      0,
      (sum, line) => sum + line.quantity,
    );

    // Calculate discount from coupon codes
    double couponDiscount = 0.0;
    if (order.discounts.isNotEmpty) {
      couponDiscount = order.discounts.fold<double>(
        0.0,
        (sum, discount) => sum + discount.amountWithTax,
      );
    }

    // Loyalty points from order customFields; discount in rupees from fetch loyalty config (Points per Rupee)
    final loyaltyPointsUsed = order.customFields?.loyaltyPointsUsed ?? 0;
    final loyaltyPointsEarned = order.customFields?.loyaltyPointsEarned ?? 0;
    double loyaltyDiscountRupees = 0.0;
    if (loyaltyPointsUsed > 0 && loyaltyConfig != null) {
      final pointsPerRupee = loyaltyConfig.pointsPerRupee as int?;
      if (pointsPerRupee != null && pointsPerRupee > 0) {
        loyaltyDiscountRupees = loyaltyPointsUsed / pointsPerRupee.toDouble();
      } else {
        loyaltyDiscountRupees = loyaltyPointsUsed.toDouble();
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        // Add back coupon + loyalty discounts to show original subtotal
        _buildTotalRow('Subtotal', order.subTotalWithTax + couponDiscount.abs() + (loyaltyDiscountRupees * 100)),
        _buildTotalRow('Total Qty', totalQuantity.toDouble(), isQuantity: true),
        _buildTotalRow('Shipping', order.shippingWithTax),
        // Show coupon codes if applied (show even if discount is 0, as coupon might have other effects)
        if (order.couponCodes.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('Coupon (${_safeString(order.couponCodes.join(", "))}): ',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.green700)),
              if (couponDiscount > 0)
                pw.Text('-${BillGenerator.formatPriceForPdf(couponDiscount.toInt())}',
                    style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.green700,
                        fontWeight: pw.FontWeight.bold))
              else
                pw.Text('Applied',
                    style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.green700,
                        fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
        // Show loyalty points used if applied
        if (loyaltyPointsUsed > 0) ...[
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('Points Applied: ',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.blue700)),
              pw.Text('-${BillGenerator.formatPriceForPdf((loyaltyDiscountRupees * 100).toInt())}',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.blue700,
                      fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
        pw.SizedBox(height: 4),
        pw.Divider(),
        _buildTotalRow('Total', order.totalWithTax,
            isBold: true, fontSize: 16),
        // Show loyalty points earned if any (with Rs. equivalent from Points per Rupee when config available)
        if (loyaltyPointsEarned > 0) ...[
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('Points Earned: ',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.green700)),
              pw.Text(
                loyaltyConfig != null &&
                        (loyaltyConfig.pointsPerRupee as int? ?? 0) > 0
                    ? '${loyaltyPointsEarned} pts (${BillGenerator.formatPriceForPdf((loyaltyPointsEarned / (loyaltyConfig.pointsPerRupee as int) * 100.0).toInt())})'
                    : '${loyaltyPointsEarned} pts',
                style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.green700,
                    fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildTotalRow(String label, double amount,
      {bool isBold = false, double fontSize = 12, bool isQuantity = false}) {
    final valueText = isQuantity
        ? amount.toInt().toString()
        : BillGenerator.formatPriceForPdf(amount.toInt());
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text('$label: ',
            style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                fontSize: fontSize)),
        pw.Text(valueText,
            style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                fontSize: fontSize)),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 8),
        pw.Text('Thank you for your business!',
            style: pw.TextStyle(
                color: PdfColors.grey600,
                fontSize: 12)),
        pw.SizedBox(height: 12),
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.Text('FSSAI License Number: 12422012001406',
            style: pw.TextStyle(
                color: PdfColors.grey700,
                fontSize: 10)),
        pw.SizedBox(height: 4),
        pw.Text('GST No: 33BFHPS5919D2ZD',
            style: pw.TextStyle(
                color: PdfColors.grey700,
                fontSize: 10)),
      ],
    );
  }
}
