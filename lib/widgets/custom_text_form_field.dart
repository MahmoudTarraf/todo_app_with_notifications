import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/utils/text_direction_helper.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String) onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onEditingComplete;
  final double containerWidth;

  const CustomTextFormField({
    super.key,
    required this.containerWidth,
    required this.hintText,
    required this.suffixIcon,
    required this.prefixIcon,
    this.validator,
    required this.keyboardType,
    required this.obscureText,
    required this.onChanged,
    this.onSaved,
    this.onEditingComplete,
  });

  Widget _enterCustomTextFormField(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: containerWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: theme.dividerColor,
        ),
        // ignore: deprecated_member_use
        color: theme.cardColor.withOpacity(0.7),
      ),
      child: TextFormField(
        textDirection: TextDirectionHelper.currentDirection,
        onChanged: onChanged,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        onSaved: onSaved,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          icon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: theme.dividerColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _enterCustomTextFormField(context);
  }
}
