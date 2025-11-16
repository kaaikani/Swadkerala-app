import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextButtonField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const TextButtonField({
    Key? key,
    required this.controller,
    this.hint = '',
    this.obscureText = false,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () {
              if (onTap != null) {
                onTap!();
              } else {
                FocusScope.of(context).requestFocus(FocusNode());
              }
            }
          : null,
      child: AbsorbPointer(
        absorbing: false,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          enabled: enabled,
          textCapitalization: textCapitalization,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixText: prefixText,
            hintText: hint,
            filled: true,
            fillColor: enabled
                ? Colors.blue.shade50
                : Colors.grey.shade200, // button-style background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
          style: TextStyle(
            color: enabled ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
