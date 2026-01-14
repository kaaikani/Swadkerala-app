import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.rp(32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.rp(80),
                color: Colors.grey[300],
              ),
              SizedBox(height: ResponsiveUtils.rp(24)),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveUtils.sp(18),
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveUtils.rp(12)),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                      fontSize: ResponsiveUtils.sp(14),
                    ),
                textAlign: TextAlign.center,
              ),
              if (action != null) ...[
                SizedBox(height: ResponsiveUtils.rp(24)),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
