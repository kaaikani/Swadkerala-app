import 'package:flutter/material.dart';
import '../../controllers/banner/bannercontroller.dart';
import '../../theme/colors.dart';
import '../../utils/responsive.dart';
import '../../utils/analytics_helper.dart';

class CartOtherInstructionsSection extends StatefulWidget {
  final BannerController bannerController;
  final Function(String) onSaveInstructions;

  const CartOtherInstructionsSection({
    super.key,
    required this.bannerController,
    required this.onSaveInstructions,
  });

  @override
  State<CartOtherInstructionsSection> createState() => _CartOtherInstructionsSectionState();
}

class _CartOtherInstructionsSectionState extends State<CartOtherInstructionsSection> {
  final _otherInstructionsController = TextEditingController();
  final FocusNode _otherInstructionsFocusNode = FocusNode();
  bool _showInstructionsOptions = false;
  bool _showOtherTextField = false;
  String? _selectedDefaultInstruction;

  // Default instruction options
  final List<String> _defaultInstructions = [
    'Leave at door',
    'Call before delivery',
    'Special packaging required',
  ];

  @override
  void dispose() {
    _otherInstructionsController.dispose();
    _otherInstructionsFocusNode.dispose();
    super.dispose();
  }

  void _saveOtherInstructions(String instructions) {
    widget.onSaveInstructions(instructions);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.rp(12)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(12)),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.note_rounded,
                    color: AppColors.warning,
                    size: ResponsiveUtils.rp(16),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(8)),
                  Text(
                    'Additional Instructions',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.rp(4)),
                  Text(
                    '(Optional)',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(11),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (!_showInstructionsOptions)
                TextButton(
                  onPressed: AnalyticsHelper.trackButton(
                    'Show More - Delivery Instructions',
                    screenName: 'Cart',
                    callback: () {
                      setState(() {
                        _showInstructionsOptions = true;
                      });
                    },
                  ),
                  child: Text(
                    'Show more',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.button,
                    ),
                  ),
                )
              else
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showInstructionsOptions = false;
                      _showOtherTextField = false;
                      _selectedDefaultInstruction = null;
                      _otherInstructionsController.clear();
                    });
                  },
                  child: Text(
                    'Show less',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.button,
                    ),
                  ),
                ),
            ],
          ),
          if (_showInstructionsOptions) ...[
            SizedBox(height: ResponsiveUtils.rp(12)),
            if (!_showOtherTextField) ...[
              ..._defaultInstructions.map((instruction) {
                final isSelected = _selectedDefaultInstruction == instruction;
                return Container(
                  margin: EdgeInsets.only(bottom: ResponsiveUtils.rp(8)),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDefaultInstruction = instruction;
                        _otherInstructionsController.text = instruction;
                        _showOtherTextField = false;
                      });
                      _saveOtherInstructions(instruction);
                    },
                    child: Container(
                      padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.button.withOpacity(0.1)
                            : AppColors.inputFill,
                        borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.button
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ResponsiveUtils.rp(16),
                            height: ResponsiveUtils.rp(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.button
                                    : AppColors.border,
                                width: 2,
                              ),
                              color: isSelected
                                  ? AppColors.button
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: ResponsiveUtils.rp(12),
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(width: ResponsiveUtils.rp(8)),
                          Expanded(
                            child: Text(
                              instruction,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(12),
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: ResponsiveUtils.rp(8)),
              InkWell(
                onTap: () {
                  setState(() {
                    _showOtherTextField = true;
                    _selectedDefaultInstruction = null;
                    _otherInstructionsController.text = '';
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: ResponsiveUtils.rp(16), color: AppColors.button),
                      SizedBox(width: ResponsiveUtils.rp(8)),
                      Text(
                        'Other',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.sp(12),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_showOtherTextField) ...[
              SizedBox(height: ResponsiveUtils.rp(8)),
              TextField(
                controller: _otherInstructionsController,
                focusNode: _otherInstructionsFocusNode,
                maxLines: 2,
                style: TextStyle(fontSize: ResponsiveUtils.sp(12)),
                decoration: InputDecoration(
                  hintText: 'Enter custom instructions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ResponsiveUtils.rp(8)),
                  ),
                  contentPadding: EdgeInsets.all(ResponsiveUtils.rp(10)),
                ),
                onChanged: (value) {
                  _saveOtherInstructions(value);
                },
              ),
            ],
          ],
        ],
      ),
    );
  }
}

