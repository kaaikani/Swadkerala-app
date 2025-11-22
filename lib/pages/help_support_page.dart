import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/customer/customer_controller.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import '../widgets/premium_card.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();
    final customer = customerController.activeCustomer.value;
    final customerName = customer != null
        ? '${customer.firstName} ${customer.lastName}'.trim()
        : 'User';
    final customerPhone = customer?.phoneNumber ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: ResponsiveUtils.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ResponsiveUtils.rp(16)),
            // Contact Options
            PremiumCard(
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get in Touch',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  _buildContactTile(
                    icon: Icons.phone_outlined,
                    title: 'Phone Support',
                    subtitle: '+91 1234567890',
                    color: AppColors.success,
                    onTap: () => _launchPhone('+911234567890'),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildContactTile(
                    icon: Icons.chat_outlined,
                    title: 'WhatsApp',
                    subtitle: 'Chat with us on WhatsApp',
                    color: Color(0xFF25D366),
                    onTap: () => _launchWhatsApp(customerName, customerPhone),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildContactTile(
                    icon: Icons.email_outlined,
                    title: 'Email Support',
                    subtitle: 'support@yourcompany.com',
                    color: AppColors.button,
                    onTap: () => _launchEmail('support@yourcompany.com'),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
            // FAQ Section
            PremiumCard(
              margin: EdgeInsets.symmetric(horizontal: ResponsiveUtils.rp(16)),
              padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(16)),
                  _buildFAQItem(
                    question: 'How do I place an order?',
                    answer: 'Browse products, add to cart, and proceed to checkout. Follow the steps to complete your order.',
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildFAQItem(
                    question: 'What are the delivery charges?',
                    answer: 'Delivery charges vary based on your location and order value. Free delivery is available for orders above a certain amount.',
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildFAQItem(
                    question: 'How can I track my order?',
                    answer: 'You can track your order from the "My Orders" section in your account. You will receive updates via SMS and email.',
                  ),
                  SizedBox(height: ResponsiveUtils.rp(12)),
                  _buildFAQItem(
                    question: 'Can I cancel my order?',
                    answer: 'Yes, you can request cancellation from the order details page if your order hasn\'t been shipped yet.',
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveUtils.rp(16)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveUtils.rp(48),
              height: ResponsiveUtils.rp(48),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
              ),
              child: Icon(icon, color: Colors.white, size: ResponsiveUtils.rp(24)),
            ),
            SizedBox(width: ResponsiveUtils.rp(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: ResponsiveUtils.rp(4)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(13),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveUtils.rp(16),
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(15),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: ResponsiveUtils.rp(8)),
          Text(
            answer,
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14),
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    try {
      final url = Uri.parse('tel:$phoneNumber');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showErrorSnackbar('Could not make phone call');
      }
    } catch (e) {
      _showErrorSnackbar('Error opening phone');
    }
  }

  Future<void> _launchWhatsApp(String name, String phoneNumber) async {
    try {
      // Format phone number (remove + and spaces)
      final cleanPhone = phoneNumber.replaceAll(RegExp(r'[+\s]'), '');
      
      // WhatsApp URL with pre-filled message containing name and phone
      // Content is empty as requested
      final message = 'Name: $name\nPhone: $phoneNumber\n\n';
      final encodedMessage = Uri.encodeComponent(message);
      final url = Uri.parse('https://wa.me/$cleanPhone?text=$encodedMessage');
      
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackbar('Could not open WhatsApp');
      }
    } catch (e) {
      _showErrorSnackbar('Error opening WhatsApp');
    }
  }

  Future<void> _launchEmail(String email) async {
    try {
      final url = Uri.parse('mailto:$email');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showErrorSnackbar('Could not open email app');
      }
    } catch (e) {
      _showErrorSnackbar('Error opening email');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}




