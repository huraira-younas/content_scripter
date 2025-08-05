import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show errorDialogue;
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/screens/forgot_password_screen/widgets/pin_box.dart';
import 'package:content_scripter/blocs/timer_bloc/timer_bloc.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:content_scripter/cubits/otp_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _pinController = List.generate(6, (index) => TextEditingController());
  final _loader = LoadingScreen.instance();
  final _focusNode = FocusNode();

  Future<void> verifyOTP() async {
    final code = _pinController.fold(
        "", (previousValue, element) => previousValue + element.text.trim());
    if (code.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter OTP");
      return;
    }

    context.read<OtpCubit>().verifyOtp(email: widget.email, otp: code);
  }

  void showError(String  title, String message) => errorDialogue(
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
              case OtpEvent.sent:
                for (final controller in _pinController) {
                  controller.clear();
                }
                _focusNode.requestFocus();
                BlocProvider.of<TimerBloc>(context).add(
                  StartTimer(duration: 60),
                );

                return;
              case OtpEvent.verified:
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.createNewPasswordScreen,
                  arguments: widget.email,
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
                Image.asset(AppAssets.lockPng, height: 100),
                const SizedBox(height: 10),
                const MyText(
                  text: "OTP Code Verification",
                  family: AppFonts.bold,
                  size: 22,
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: "We have sent an OTP code to ",
                    style: myStyle(family: AppFonts.medium),
                    children: [
                      TextSpan(
                        text: widget.email,
                        style: myStyle(
                          family: AppFonts.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: ". Enter the OTP code below to verify",
                        style: myStyle(family: AppFonts.medium),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    _pinController.length,
                    (idx) => PinBox(
                      focusNode: idx == 0 ? _focusNode : null,
                      controller: _pinController[idx],
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      const MyText(
                        text: "Didn't recieve an OTP?",
                        size: AppConstants.subtitle,
                        family: AppFonts.medium,
                        isCenter: true,
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, state) {
                          if (state is TimerStopped) {
                            return TextButton(
                              onPressed: () => context.read<OtpCubit>().sendOtp(
                                    email: widget.email,
                                    method: "reset",
                                  ),
                              child: MyText(
                                text: 'Resend OTP',
                                color: AppColors.borderColor,
                                size: AppConstants.subtitle,
                                family: AppFonts.medium,
                              ),
                            );
                          } else if (state is TickingTimer) {
                            final minutes = ((state.duration / 60) % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                            final seconds = (state.duration % 60)
                                .floor()
                                .toString()
                                .padLeft(2, '0');
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: MyText(
                                text:
                                    'You can resend code in $minutes:$seconds',
                                color: AppColors.borderColor,
                                size: AppConstants.subtitle,
                                family: AppFonts.medium,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Verify OTP",
                    onPressed: verifyOTP,
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
    _pinController.asMap().forEach((i, e) => e.dispose());
    super.dispose();
  }
}
