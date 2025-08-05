import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show errorDialogue;
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateNewPassword extends StatefulWidget {
  final String email;
  const CreateNewPassword({super.key, required this.email});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _controllers = List.generate(2, (index) => TextEditingController());
  final _keys = List.generate(2, (index) => GlobalKey<FormState>());
  final _loader = LoadingScreen.instance();

  bool _cObsecure = true, _obsecure = true;

  void updatePassword() async {
    if (_keys.any((e) => e.currentState!.validate() == false)) {
      Fluttertoast.showToast(msg: "Please fill the form");
      return;
    }
    final email = widget.email;
    final password = _controllers.first.text.trim();
    context.read<UserBloc>().add(HandlePasswordEvent(
          password: password,
          email: email,
        ));
  }

  void showError(String title, String message) => errorDialogue(
        context: context,
        title: title,
        message: message,
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: customAppBar(context: context),
        body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            _loader.hide();
            if (state.error != null) {
              final error = state.error!;
              errorDialogue(
                context: context,
                title: error.title,
                message: error.message,
              );
            } else if (state.loading != null) {
              final loading = state.loading!;
              _loader.show(
                context: context,
                title: loading.title,
                text: loading.message,
              );
            } else if (state.loggedIn) {
              Fluttertoast.showToast(msg: "Update Successfull");
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.loginScreen,
                (route) => false,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
                Image.asset(AppAssets.lockPng, height: 100),
                const SizedBox(height: 10),
                const MyText(
                  text: "Create New Password",
                  size: 22,
                  family: AppFonts.bold,
                ),
                const SizedBox(height: 20),
                const MyText(
                  text: AppConstants.createPassText,
                  family: AppFonts.semibold,
                ),
                const SizedBox(height: 60),
                Form(
                  key: _keys[0],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    type: TextInputType.visiblePassword,
                    prefixIcon: const Icon(Icons.password),
                    label: "New Password",
                    hint: "Enter New Password",
                    obsecure: _obsecure,
                    controller: _controllers[0],
                    onChange: (p0) => _keys[1].currentState!.validate(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obsecure = !_obsecure),
                      icon: Icon(
                        _obsecure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.greyColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required New Password";
                      }
                      return value.trim().length < 8
                          ? "Password must be at least 8 characters"
                          : null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _keys[1],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.password),
                    label: "Confirm New Password",
                    hint: "Enter Confirm New Password",
                    controller: _controllers[1],
                    type: TextInputType.visiblePassword,
                    obsecure: _cObsecure,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _cObsecure = !_cObsecure),
                      icon: Icon(
                        _cObsecure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.greyColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Confirm New Password";
                      }
                      return value.trim() != _controllers[0].text.trim()
                          ? "Passwords did not match"
                          : null;
                    },
                  ),
                ),
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Continue",
                    onPressed: updatePassword,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
