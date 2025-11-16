import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/responsive.dart';
import 'responsive_text.dart';
import 'responsive_spacing.dart';

/// Reusable section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsets? padding;
  final bool showDivider;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.action,
    this.padding,
    this.showDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? ResponsiveSpacing.screenPadding,
          child: Row(
            children: [
              // Zomato red accent bar
              Container(
                width: ResponsiveUtils.rp(4),
                height: ResponsiveUtils.rp(20),
                decoration: BoxDecoration(
                  color: AppColors.zomatoRed,
                  borderRadius: BorderRadius.circular(ResponsiveUtils.rp(2)),
                ),
              ),
              ResponsiveSpacing.horizontal(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      title,
                      style: ResponsiveTextStyles.heading4(),
                      maxLines: 1,
                    ),
                    if (subtitle != null) ...[
                      ResponsiveSpacing.vertical(4),
                      ResponsiveText(
                        subtitle!,
                        style: ResponsiveTextStyles.bodySmall(),
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: AppColors.divider,
            height: ResponsiveUtils.rp(1),
            thickness: ResponsiveUtils.rp(1),
          ),
      ],
    );
  }
}
