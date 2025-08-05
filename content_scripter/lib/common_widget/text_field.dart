import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final bool obsecure;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final String? value;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType type;
  final InputBorder? border;
  final FocusNode? focusNode;
  final Function(String?)? onChange;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    this.type = TextInputType.text,
    this.obsecure = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.suffixIcon,
    this.prefixIcon,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChange,
    this.border,
    this.value,
    this.label,
    this.hint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      initialValue: value,
      onChanged: onChange,
      obscureText: obsecure,
      keyboardType: type,
      enabled: enabled,
      style: myStyle(size: AppConstants.subtitle),
      decoration: customInputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border,
        hint: hint,
        label: label,
      ),
      validator: validator,
    );
  }
}

InputDecoration customInputDecoration({
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? hint,
  String? label,
  InputBorder? border,
}) {
  final borderStyle = OutlineInputBorder(
    borderSide:
        BorderSide(color: AppColors.primaryColor.withValues(alpha: 0.1)),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
  );

  return InputDecoration(
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppConstants.padding,
      vertical: 16,
    ),
    filled: true,
    labelText: label,
    alignLabelWithHint: true,
    fillColor: AppColors.cardColor,
    errorStyle: const TextStyle(color: Colors.red),
    hintStyle: const TextStyle(color: AppColors.greyColor),
    disabledBorder: border ?? borderStyle,
    hintText: hint,
    isCollapsed: true,
    isDense: true,
    enabledBorder: border ?? borderStyle,
    errorBorder: border ?? borderStyle,
    border: border ?? borderStyle,
  );
}
