import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../controllers/order/ordermodels.dart' as order_models;
import '../utils/price_formatter.dart';

class BillGenerator {
  static Future<void> generateAndShare(order_models.OrderModel order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(order),
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

    // Save PDF to temporary file and share it
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

  static pw.Widget _buildHeader(order_models.OrderModel order) {
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
        // Add Logo here if available
        pw.Text('Kaaikani',
            style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue600)),
      ],
    );
  }

  static pw.Widget _buildInfoSection(order_models.OrderModel order) {
    // Get customer name
    final customerName = order.shippingAddress != null
        ? order.shippingAddress!.fullName
        : 'Customer';
    
    // Get order date
    final orderDate = order.orderPlacedAt != null
        ? order.orderPlacedAt.toString().split(' ')[0]
        : DateTime.now().toString().split(' ')[0];
    
    // Get payment method
    final paymentMethod = order.payments.isNotEmpty
        ? order.payments.first.method
        : 'N/A';
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
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Billed To:',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text(customerName),
                if (order.shippingAddress != null) ...[
                  if (order.shippingAddress!.streetLine1.isNotEmpty)
                    pw.Text(order.shippingAddress!.streetLine1),
                  if (order.shippingAddress!.city.isNotEmpty)
                    pw.Text(order.shippingAddress!.city),
                  if (order.shippingAddress!.postalCode.isNotEmpty)
                    pw.Text(order.shippingAddress!.postalCode),
                ],
              ],
            ),
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
      ],
    );
  }

  static pw.Widget _buildItemsTable(order_models.OrderModel order) {
    final headers = ['Item', 'Qty', 'Price', 'Total'];
    final data = order.lines.map((line) {
      return [
        line.productVariant.name,
        '${line.quantity}',
        PriceFormatter.formatPrice(line.unitPriceWithTax.toInt()),
        PriceFormatter.formatPrice(line.linePriceWithTax.toInt()),
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

  static pw.Widget _buildTotalsSection(order_models.OrderModel order) {
    // Calculate discount from coupon codes
    double couponDiscount = 0.0;
    if (order.discounts.isNotEmpty) {
      couponDiscount = order.discounts.fold<double>(
        0.0,
        (sum, discount) => sum + discount.amountWithTax.toDouble(),
      );
    }
    
    // Get loyalty points info
    final loyaltyPointsUsed = order.customFields?.loyaltyPointsUsed ?? 0;
    final loyaltyPointsEarned = order.customFields?.loyaltyPointsEarned ?? 0;
    // Assuming 1 point = 1 rupee (adjust as needed)
    final loyaltyDiscount = loyaltyPointsUsed.toDouble();
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        _buildTotalRow('Subtotal', order.subTotalWithTax.toDouble()),
        _buildTotalRow('Shipping', order.shippingWithTax.toDouble()),
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
              pw.Text('-${PriceFormatter.formatPrice(couponDiscount.toInt())}',
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
              pw.Text('-${PriceFormatter.formatPrice(loyaltyDiscount.toInt())}',
                  style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.blue700,
                      fontWeight: pw.FontWeight.bold)),
            ],
          ),
        ],
        pw.SizedBox(height: 4),
        pw.Divider(),
        _buildTotalRow('Total', order.totalWithTax.toDouble(),
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
        pw.Text(PriceFormatter.formatPrice(amount.toInt()),
            style: pw.TextStyle(
                fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
                fontSize: fontSize)),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Text('Thank you for your business!',
          style: pw.TextStyle(color: PdfColors.grey600)),
    );
  }
}
