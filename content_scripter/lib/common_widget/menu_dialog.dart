import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MenuDialog extends StatefulWidget {
  final String title;
  final bool isEmail;
  final String? value;
  final String? description;
  const MenuDialog({
    required this.title,
    this.isEmail = false,
    this.description,
    this.value,
    super.key,
  });

  @override
  State<MenuDialog> createState() => _MenuDialogState();
}

class _MenuDialogState extends State<MenuDialog> {
  late final user = context.read<UserBloc>().user!;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final label = widget.isEmail ? "Email" : "Name";
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? validate(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a $label';
    }
    if (widget.isEmail && !AppUtils.isEmail(value)) {
      return "Please enter a valid email address";
    }
    if (widget.isEmail && value.toLowerCase() == user.email) {
      return "You can not shared the history with yourself";
    }
    return null;
  }

  void handleChange() {
    final text = _controller.text.trim().toLowerCase();
    final value = widget.value?.trim().toLowerCase();
    setState(() => _isEditing = text != value);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width * 0.8;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
        child: Material(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(10),
              color: AppColors.cardColor,
            ),
            width: w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyText(
                  size: AppConstants.title,
                  family: AppFonts.bold,
                  text: widget.title,
                ),
                if (widget.description != null) ...[
                  Divider(
                    color: AppColors.borderColor.withValues(alpha: 0.1),
                    height: 30,
                  ),
                  MyText(text: widget.description!),
                ],
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    onChange: (p0) => handleChange(),
                    validator: validate,
                    controller: _controller,
                    hint: "Enter $label",
                    label: label,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        borderColor: AppColors.borderColor,
                        bgColor: Colors.transparent,
                        text: "Cancel",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        text: "Submit",
                        onPressed: _isEditing
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  final String folderName =
                                      _controller.text.trim();
                                  Navigator.of(context).pop(folderName);
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
