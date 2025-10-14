import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/sizes.dart';

class AddressCard extends StatelessWidget {
  final String fullName;
  final String streetLine1;
  final String? streetLine2;
  final String city;
  final String? province;
  final String postalCode;
  final String country;
  final String? phoneNumber;
  final bool isShipping;
  final bool isBilling;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    Key? key,
    required this.fullName,
    required this.streetLine1,
    this.streetLine2,
    required this.city,
    this.province,
    required this.postalCode,
    required this.country,
    this.phoneNumber,
    this.isShipping = false,
    this.isBilling = false,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: isShipping || isBilling
              ? AppColors.primary.withOpacity(0.3)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (onEdit != null && onDelete != null) const SizedBox(width: 8),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: AppColors.error),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            streetLine1,
            style: TextStyle(color: Colors.grey[700]),
          ),
          if (streetLine2 != null && streetLine2!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              streetLine2!,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            '$city${province != null ? ', $province' : ''} $postalCode',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            country,
            style: TextStyle(color: Colors.grey[700]),
          ),
          if (phoneNumber != null && phoneNumber!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  phoneNumber!,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ],
          if (isShipping || isBilling) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (isShipping)
                  Chip(
                    label: const Text('Shipping', style: TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppColors.primary),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                if (isBilling)
                  Chip(
                    label: const Text('Billing', style: TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.accent.withOpacity(0.1),
                    labelStyle: const TextStyle(color: AppColors.accent),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

