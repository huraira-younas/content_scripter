import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show LengthLimitingTextInputFormatter, FilteringTextInputFormatter;

class PinBox extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController controller;
  const PinBox({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: 56,
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: customInputDecoration().copyWith(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.only(
            left: 7,
            right: 4,
            top: 4,
            bottom: 4,
          ),
        ),
        style: myStyle(
          size: AppConstants.titleLarge + 10,
          family: AppFonts.medium,
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
