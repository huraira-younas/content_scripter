import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show errorDialogue;
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/common_widget/custom_checkbox.dart';
import 'package:content_scripter/blocs/timer_bloc/timer_bloc.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/models/phone_model.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:content_scripter/cubits/otp_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _controllers = List.generate(6, (index) => TextEditingController());
  final _loader = LoadingScreen.instance();
  final _keys = List.generate(5, (index) => GlobalKey<FormState>());
  final _otpKey = GlobalKey<FormState>();
  bool otp = false;
  Country? _country;
  bool _termsCond = false,
      _cObsecure = true,
      _isValidOtp = true,
      _obsecure = true,
      _isEmail = false;

  void registerUser() async {
    FocusScope.of(context).unfocus();
    final name = _controllers[0].text.trim();
    final email = _controllers[1].text.trim();
    final phone = _controllers[3].text.trim();
    final pass = _controllers[4].text.trim();
    final userOtp = _controllers[2].text.trim();

    if (_keys.any((key) => key.currentState!.validate() == false)) {
      Fluttertoast.showToast(msg: "Please Fill The Form");
      return;
    }

    if (!_otpKey.currentState!.validate()) {
      setState(() => _isValidOtp = false);
      Fluttertoast.showToast(msg: "Please submit the OTP");
      return;
    }

    if (!_termsCond) {
      Fluttertoast.showToast(msg: "Accept the Terms and Conditions");
      return;
    }

    context.read<UserBloc>().add(SignUpEvent(
          name: name,
          email: email,
          otp: userOtp,
          password: pass,
          phone: PhoneModel(
            phoneCode: _country!.phoneCode,
            code: _country!.countryCode,
            country: _country!.name,
            number: phone,
          ),
        ));
  }

  void sentOTP() {
    FocusScope.of(context).unfocus();
    final email = _controllers[1].text.trim();
    context.read<OtpCubit>().sendOtp(email: email);
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
                setState(() => otp = true);
                BlocProvider.of<TimerBloc>(context).add(StartTimer(
                  duration: 60,
                ));
                Fluttertoast.showToast(msg: state.message);
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height * 0.04),
                Row(
                  children: <Widget>[
                    const MyText(
                      text: "Create Account",
                      size: 22,
                      family: AppFonts.bold,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(AppAssets.welcomePng, height: 30),
                  ],
                ),
                const SizedBox(height: 10),
                const MyText(
                  family: AppFonts.semibold,
                  color: AppColors.greyColor,
                  text:
                      "Please enter your email & password to create an account.",
                ),
                const SizedBox(height: 60),
                Form(
                  key: _keys[0],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.person),
                    type: TextInputType.emailAddress,
                    label: "Name",
                    hint: "Enter Name",
                    controller: _controllers[0],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Name";
                      }
                      return value.trim().length < 4
                          ? "Name length must be at least 4 characters"
                          : null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _keys[1],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.email),
                    label: "Email",
                    hint: "Enter Email",
                    type: TextInputType.emailAddress,
                    controller: _controllers[1],
                    onChange: (_) => setState(() {
                      _isEmail = _keys[1].currentState!.validate();
                    }),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Email";
                      }
                      return !AppUtils.isEmail(value)
                          ? "Invalid email address"
                          : null;
                    },
                    suffixIcon: BlocBuilder<TimerBloc, TimerState>(
                      builder: (context, state) {
                        if (state is TimerStopped) {
                          return IconButton(
                            onPressed: _isEmail ? () => sentOTP() : null,
                            icon: Icon(
                              Icons.send,
                              color: _isEmail ? AppColors.primaryColor : null,
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
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 30,
                            child: Center(
                              child: MyText(
                                text: '$minutes:$seconds',
                                color: AppColors.primaryColor,
                                family: AppFonts.medium,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: AnimatedContainer(
                        height: state is TickingTimer ? 0 : 24,
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.only(left: 14.0, top: 6),
                        child: const MyText(
                          text: "Click on arrow to get OTP",
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                AnimatedContainer(
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(),
                  duration: const Duration(milliseconds: 500),
                  height: !otp
                      ? 0.0
                      : _isValidOtp
                          ? 90
                          : 108,
                  child: Form(
                    key: _otpKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: CustomTextField(
                      prefixIcon: const Icon(Icons.lock),
                      onChange: (p0) {
                        setState(
                            () => _isValidOtp = p0 != null && p0.isNotEmpty);
                      },
                      type: TextInputType.phone,
                      hint: "Enter OTP",
                      label: "OTP",
                      border: otp ? null : InputBorder.none,
                      controller: _controllers[2],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Required otp";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Form(
                  key: _keys[2],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    type: TextInputType.phone,
                    prefixIcon: TextButton(
                      onPressed: () => _buildCountryPicker(
                        context,
                        (country) => setState(() => _country = country),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(width: 8),
                          MyText(
                            text: "+${_country?.phoneCode ?? '1'}",
                            size: AppConstants.subtitle,
                            color: _country != null
                                ? AppColors.whiteColor
                                : AppColors.greyColor,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: _country != null
                                ? AppColors.whiteColor
                                : AppColors.greyColor,
                          ),
                        ],
                      ),
                    ),
                    label: "Phone Number",
                    hint: "Enter Phone Number",
                    controller: _controllers[3],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Phone Number";
                      }
                      if (_country == null) {
                        return "Required Phone Code";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _keys[3],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.password),
                    type: TextInputType.visiblePassword,
                    label: "Password",
                    hint: "Enter Password",
                    obsecure: _obsecure,
                    controller: _controllers[4],
                    onChange: (p0) => _keys[4].currentState!.validate(),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obsecure = !_obsecure),
                      icon: Icon(
                        _obsecure ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.greyColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Password";
                      }
                      return value.trim().length < 8
                          ? "Password must be at least 8 characters"
                          : null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _keys[4],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.password),
                    label: "Confirm Password",
                    hint: "Enter Confirm Password",
                    controller: _controllers[5],
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
                        return "Required Confirm Password";
                      }
                      return value.trim() != _controllers[4].text.trim()
                          ? "Passwords did not match"
                          : null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setState(() => _termsCond = !_termsCond),
                      child: CustomCheckBox(isChecked: _termsCond),
                    ),
                    const SizedBox(width: 10),
                    const MyText(
                      text: "Accept to our Terms and Conditions",
                      family: AppFonts.medium,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Sign up",
                    onPressed: registerUser,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const MyText(
                      text: "Already have an account?",
                      family: AppFonts.semibold,
                      color: AppColors.greyColor,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const MyText(
                        text: "Login",
                        family: AppFonts.semibold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.asMap().forEach((i, e) => e.dispose());
    super.dispose();
  }
}

void _buildCountryPicker(BuildContext context, Function(Country) onSelect) {
  showCountryPicker(
    showPhoneCode: true,
    context: context,
    countryListTheme: CountryListThemeData(
      flagSize: 20,
      backgroundColor: AppColors.secondaryColor,
      textStyle: const TextStyle(
        color: AppColors.primaryColor,
        fontSize: 16,
      ),
      searchTextStyle: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16,
      ),
      bottomSheetHeight: 500,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      inputDecoration: customInputDecoration(
        hint: "Start typing to search...",
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.whiteColor,
        ),
      ),
    ),
    onSelect: onSelect,
  );
}
