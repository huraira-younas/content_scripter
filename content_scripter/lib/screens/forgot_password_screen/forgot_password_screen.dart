import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show errorDialogue;
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:content_scripter/cubits/otp_cubit.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _loader = LoadingScreen.instance();
  final _key = GlobalKey<FormState>();
  final _controller = TextEditingController();

  void sentOTP() {
    FocusScope.of(context).unfocus();
    if (!_key.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please enter email address");
      return;
    }
    final email = _controller.text.trim();
    context.read<OtpCubit>().sendOtp(email: email, method: "reset");
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
        body: BlocListener<OtpCubit, OtpState>(
          listener: (context, state) {
            _loader.hide();
            switch (state.event) {
              case OtpEvent.error:
                showError(state.title, state.message);
                return;
              case OtpEvent.sending:
                _loader.show(
                  context: context,
                  title: state.title,
                  text: state.message,
                );
                return;
              default:
                Navigator.of(context).pushNamed(
                  AppRoutes.verifyOtpScreen,
                  arguments: _controller.text.trim(),
                );
                Fluttertoast.showToast(msg: state.message);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
                Image.asset(AppAssets.appLogoPng, height: 100),
                const MyText(
                  text: "Reset Your Password",
                  size: 22,
                  family: AppFonts.bold,
                ),
                const SizedBox(height: 20),
                const MyText(
                  text: AppConstants.resetPassText,
                  family: AppFonts.semibold,
                ),
                const SizedBox(height: 60),
                Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    type: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    label: "Email",
                    hint: "Enter Email",
                    controller: _controller,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Email";
                      }
                      return !AppUtils.isEmail(value)
                          ? "Invalid email address"
                          : null;
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Send OTP",
                    onPressed: sentOTP,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
