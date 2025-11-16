import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/responsive.dart';
import '../theme/colors.dart';
import '../widgets/responsive_container.dart';
import '../widgets/responsive_spacing.dart';
import '../widgets/responsive_text.dart';
import '../widgets/responsive_icon.dart';

class TwoActionRow extends StatelessWidget {
  const TwoActionRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      backgroundColor: AppColors.surface,
      padding: ResponsiveSpacing.padding(horizontal: 20, vertical: 16),
      borderRadius: BorderRadius.zero,
      boxShadow: [],
      child: Row(
        children: [
          Expanded(
            child: _ActionCard(
              icon: Icons.favorite_rounded,
              label: 'Favourites',
              gradient: LinearGradient(
                colors: [AppColors.zomatoRed, AppColors.zomatoRedLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Get.toNamed('/favourite'),
            ),
          ),
          ResponsiveSpacing.horizontal(16),
          Expanded(
            child: _ActionCard(
              icon: Icons.history_rounded,
              label: 'Frequently List',
              gradient: LinearGradient(
                colors: [AppColors.zomatoOrange, AppColors.zomatoOrangeLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onTap: () => Get.toNamed('/orders'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.rp(18),
              horizontal: ResponsiveUtils.rp(16)),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(ResponsiveUtils.rp(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: ResponsiveUtils.rp(16),
                offset: Offset(0, ResponsiveUtils.rp(6)),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: ResponsiveUtils.rp(8),
                offset: Offset(0, ResponsiveUtils.rp(3)),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveContainer(
                padding: ResponsiveSpacing.padding(all: 6),
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(ResponsiveUtils.rp(10)),
                boxShadow: [],
                child: ResponsiveIcon(icon, color: Colors.white, size: 20),
              ),
              ResponsiveSpacing.horizontal(10),
              Flexible(
                child: ResponsiveText(
                  label,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    letterSpacing: ResponsiveUtils.rp(0.5),
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, ResponsiveUtils.rp(1)),
                        blurRadius: ResponsiveUtils.rp(2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
