import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

class PasswordManagerScreen extends StatefulWidget {
  const PasswordManagerScreen({super.key});

  @override
  State<PasswordManagerScreen> createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final _controllers = List.generate(3, (index) => TextEditingController());
  final _keys = List.generate(3, (index) => GlobalKey<FormState>());
  final _obsecures = List.generate(3, (index) => true);
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: customAppBar(context: context),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.padding + 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: size.height * 0.04),
              BlocListener<UserBloc, UserState>(
                listenWhen: (_, c) => c.loading == null,
                listener: (context, state) {
                  if (state.error != null) return;
                  Fluttertoast.showToast(
                    msg: "Password updated successfully",
                  );
                  Navigator.of(context).pop();
                },
                child: Image.asset(AppAssets.lockPng, height: 100),
              ),
              const SizedBox(height: 10),
              const MyText(
                text: "Password Manager",
                family: AppFonts.bold,
                size: 22,
              ),
              const SizedBox(height: 20),
              Form(
                key: _keys[0],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                  controller: _controllers[0],
                  type: TextInputType.visiblePassword,
                  prefixIcon: const Icon(Icons.password),
                  hint: "Current Password",
                  obsecure: _obsecures[0],
                  onChange: (p0) => setState(
                    () => _isEditing = p0?.isNotEmpty ?? false,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obsecures[0] = !_obsecures[0]),
                    icon: Icon(
                      _obsecures[0]
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.greyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required New Password";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.forgotPasswordScreen,
                      arguments: true,
                    );
                  },
                  child: const MyText(
                    color: AppColors.primaryColor,
                    text: "Forgot Password?",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: _keys[1],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                  controller: _controllers[1],
                  type: TextInputType.visiblePassword,
                  prefixIcon: const Icon(Icons.password),
                  hint: "New Password",
                  obsecure: _obsecures[1],
                  onChange: (p0) => _keys[2].currentState!.validate(),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obsecures[1] = !_obsecures[1]),
                    icon: Icon(
                      _obsecures[1]
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.greyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required New Password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _keys[2],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                  controller: _controllers[2],
                  type: TextInputType.visiblePassword,
                  hint: "Confirm New Password",
                  prefixIcon: const Icon(Icons.password),
                  obsecure: _obsecures[2],
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obsecures[2] = !_obsecures[2]),
                    icon: Icon(
                      _obsecures[2]
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.greyColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required Confirm New Password";
                    }
                    if (value.trim() != _controllers[1].text.trim()) {
                      return "Password does not match";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  onPressed: _isEditing ? updatePassword : null,
                  text: "Save",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updatePassword() async {
    FocusScope.of(context).unfocus();
    if (_keys.any((e) => !e.currentState!.validate())) {
      Fluttertoast.showToast(msg: "Please fill the fields");
      return;
    }
    final userBloc = context.read<UserBloc>();
    final password = _controllers[1].text.trim();
    final oldPassword = _controllers[0].text.trim();
    context.read<UserBloc>().add(HandlePasswordEvent(
          email: userBloc.user!.email,
          oldPassword: oldPassword,
          password: password,
        ));
  }

  @override
  void dispose() {
    _controllers.asMap().forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }
}
