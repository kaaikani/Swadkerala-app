import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';
import '../graphql/order.graphql.dart';

class BillGenerator {
  /// Format price for PDF with rupee symbol
  /// Converts paise to rupees and adds ₹ symbol
  static String formatPriceForPdf(int priceInPaise) {
    final amount = priceInPaise / 100;
    final bool isWholeNumber = (amount % 1).abs() < 0.0001;
    final String value =
        isWholeNumber ? amount.toInt().toString() : amount.toStringAsFixed(2);
    return '₹ $value';
  }
  
  /// Format price for PDF from double (already in rupees)
  static String formatPriceForPdfFromDouble(double priceInRupees) {
    final bool isWholeNumber = (priceInRupees % 1).abs() < 0.0001;
    final String value =
        isWholeNumber ? priceInRupees.toInt().toString() : priceInRupees.toStringAsFixed(2);
    return '₹ $value';
  }
  static Future<void> generateAndShare(Fragment$Cart order) async {
    // Pre-load logo image asynchronously to avoid blocking
    final box = GetStorage();
    final channelType = box.read('channel_type')?.toString() ?? '';
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

    // Generate PDF efficiently
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
            _buildTotalsSection(order),
            pw.SizedBox(height: 40),
            _buildFooter(),
          ];
        },
      ),
    );

    // Save PDF to temporary file
    final bytes = await pdf.save();
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/invoice_${order.code}.pdf');
    await file.writeAsBytes(bytes);
    
    // Share the PDF file
    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Invoice for Order #${order.code}',
      subject: 'Invoice - Order #${order.code}',
    );
  }

  static pw.Widget _buildHeader(Fragment$Cart order, pw.Image? logoImage) {
    // Get channel name
    final box = GetStorage();
    final channelName = box.read('channel_name')?.toString() ?? 
                       box.read('channel_code')?.toString() ?? 
                       'Kaaikani';
    
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
            pw.Text('Order #${order.code}',
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
    // Access order as dynamic to get extended fields (Query$GetOrderByCode$orderByCode)
    final orderDynamic = order as dynamic;
    
    // Get customer information
    final customer = orderDynamic.customer;
    final firstName = customer?.firstName ?? '';
    final lastName = customer?.lastName ?? '';
    final emailAddress = customer?.emailAddress ?? '';
    
    // Get billing address (for phone number)
    final billingAddress = orderDynamic.billingAddress;
    final billingPhone = billingAddress?.phoneNumber ?? '';
    
    // Get shipping address
    final shippingAddress = orderDynamic.shippingAddress;
    
    // Get order date
    final orderPlacedAt = orderDynamic.orderPlacedAt;
    final orderDate = orderPlacedAt != null 
        ? DateTime.parse(orderPlacedAt.toString()).toString().split(' ')[0]
        : DateTime.now().toString().split(' ')[0];
    
    // Get payment method
    final payments = orderDynamic.payments;
    String paymentMethod = 'N/A';
    if (payments != null && payments.isNotEmpty) {
      final payment = payments.first;
      paymentMethod = payment.method ?? 'N/A';
    }
    final isOnlinePayment = paymentMethod.toLowerCase().contains('razorpay') ||
        paymentMethod.toLowerCase().contains('online') ||
        paymentMethod.toLowerCase().contains('card');
    final paymentMethodText = isOnlinePayment ? 'Online Payment' : 'Offline Payment';
    
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
                pw.Text(shippingAddress.fullName),
              if (shippingAddress.streetLine1 != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(shippingAddress.streetLine1,
                    style: pw.TextStyle(fontSize: 10)),
              ],
              if (shippingAddress.streetLine2 != null && shippingAddress.streetLine2.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                pw.Text(shippingAddress.streetLine2,
                    style: pw.TextStyle(fontSize: 10)),
              ],
              pw.SizedBox(height: 2),
              pw.Text(
                [
                  if (shippingAddress.city != null) shippingAddress.city,
                  if (shippingAddress.province != null) shippingAddress.province,
                  if (shippingAddress.postalCode != null) shippingAddress.postalCode,
                ].where((e) => e != null && e.isNotEmpty).join(', '),
                style: pw.TextStyle(fontSize: 10),
              ),
              if (shippingAddress.country != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(
                  shippingAddress.country.toString(),
                  style: pw.TextStyle(fontSize: 10),
                ),
              ],
              if (shippingAddress.phoneNumber != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(shippingAddress.phoneNumber,
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
      return [
        line.productVariant.name,
        '${line.quantity}',
        BillGenerator.formatPriceForPdf(line.unitPriceWithTax.toInt()),
        BillGenerator.formatPriceForPdf(line.linePriceWithTax.toInt()),
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

  static pw.Widget _buildTotalsSection(Fragment$Cart order) {
    // Calculate discount from coupon codes
    double couponDiscount = 0.0;
    if (order.discounts.isNotEmpty) {
      couponDiscount = order.discounts.fold<double>(
        0.0,
        (sum, discount) => sum + discount.amountWithTax,
      );
    }
    
    // Get loyalty points info
    // Note: Fragment$Cart$customFields doesn't include loyalty points, so we'll use 0
    // If you need loyalty points, use Query$ActiveOrder$activeOrder instead of Fragment$Cart
    final loyaltyPointsUsed = 0;
    final loyaltyPointsEarned = 0;
    // Assuming 1 point = 1 rupee (adjust as needed)
    final loyaltyDiscount = loyaltyPointsUsed.toDouble();
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        _buildTotalRow('Subtotal', order.subTotalWithTax),
        _buildTotalRow('Shipping', order.shippingWithTax),
        // Show coupon discount if applied
        if (order.couponCodes.isNotEmpty && couponDiscount > 0) ...[
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('Coupon (${order.couponCodes.join(", ")}): ',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.green700)),
              pw.Text('-${BillGenerator.formatPriceForPdf(couponDiscount.toInt())}',
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
              pw.Text('Loyalty Points Used (${loyaltyPointsUsed} pts): ',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.blue700)),
              pw.Text('-${BillGenerator.formatPriceForPdf(loyaltyDiscount.toInt())}',
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
        // Show loyalty points earned if any
        if (loyaltyPointsEarned > 0) ...[
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.green50,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text('Loyalty Points Earned: ',
                    style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.green700)),
                pw.Text('${loyaltyPointsEarned} pts',
                    style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.green700,
                        fontWeight: pw.FontWeight.bold)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildTotalRow(String label, double amount,
      {bool isBold = false, double fontSize = 12}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text('$label: ',
            style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                fontSize: fontSize)),
        pw.Text(BillGenerator.formatPriceForPdf(amount.toInt()),
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
