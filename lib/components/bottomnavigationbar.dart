import 'package:flutter/material.dart';
import '../context/context.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';

class BottomNavComponent extends StatefulWidget {
  final int cartCount;
  final ValueChanged<int>? onTap;

  const BottomNavComponent({
    super.key,
    this.cartCount = AppContent.defaultCartCount,
    this.onTap,
  });

  @override
  State<BottomNavComponent> createState() => _BottomNavComponentState();
}

class _BottomNavComponentState extends State<BottomNavComponent> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (widget.onTap != null) widget.onTap!(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,

      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.heartInactive,
      iconSize: AppSizes.heartIconSize,
      elevation: AppSizes.cardElevation,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined,color: AppColors.icon,),
          activeIcon: const Icon(Icons.home,),
          label: AppContent.homeLabel,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.category_outlined,color: AppColors.icon),
          activeIcon: const Icon(Icons.category),
          label: AppContent.categoryLabel,
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart_outlined,color: AppColors.icon),
              if (widget.cartCount > 0)
                Positioned(
                  right: -6,
                  top: -3,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.heartActive,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${widget.cartCount}',
                      style: const TextStyle(
                        color: AppColors.buttonText,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          activeIcon: const Icon(Icons.shopping_cart),
          label: AppContent.cartLabel,
        ),
      ],
    );
  }
}
