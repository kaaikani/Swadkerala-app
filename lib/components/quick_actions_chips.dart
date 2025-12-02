import 'package:flutter/material.dart';
import '../theme/colors.dart';

class QuickActionsChips extends StatelessWidget {
  final void Function(String key) onTap;

  const QuickActionsChips({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      _Action('Offers', Icons.local_offer_outlined, 'offers'),
      _Action('Veg Only', Icons.eco_outlined, 'veg_only'),
      _Action('Near Me', Icons.near_me_outlined, 'near_me'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: actions
              .map(
                (a) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(a.icon, size: 16, color: Colors.black87),
                        const SizedBox(width: 6),
                        Text(a.label),
                      ],
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: BorderSide(color: AppColors.border),
                    onPressed: () => onTap(a.key),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final String key;
  _Action(this.label, this.icon, this.key);
}
