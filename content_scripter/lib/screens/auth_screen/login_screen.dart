import 'package:content_scripter/common_widget/card_button.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show errorDialogue;
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loader = LoadingScreen.instance();
  final _controllers = List.generate(2, (index) => TextEditingController());
  final _keys = List.generate(2, (index) => GlobalKey<FormState>());
  bool _obsecure = true;

  void loginUser({bool googleSignin = false}) async {
    FocusScope.of(context).unfocus();
    if (googleSignin) {
      return context.read<UserBloc>().add(GoogleSignInEvent());
    }
    if (_keys.any((key) => key.currentState!.validate() == false)) {
      Fluttertoast.showToast(msg: "Please fill the form");
      return;
    }
    final email = _controllers[0].text.trim();
    final pass = _controllers[1].text.trim();
    context.read<UserBloc>().add(LoginEvent(
          email: email,
          password: pass,
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
        appBar: AppBar(automaticallyImplyLeading: false),
        body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            _loader.hide();
            if (state.loading != null) {
              final loading = state.loading!;
              _loader.show(
                context: context,
                title: loading.title,
                text: loading.message,
              );
            } else if (state.error != null) {
              final error = state.error!;
              showError(error.title, error.message);
            } else if (state.loggedIn) {
              Fluttertoast.showToast(msg: "Login Successfully");
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.routesScreen,
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
                const MyText(
                  text: "Welcome To",
                  size: 22,
                  family: AppFonts.bold,
                ),
                Row(
                  children: <Widget>[
                    const MyText(
                      text: AppConstants.appname,
                      size: 22,
                      family: AppFonts.bold,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(AppAssets.welcomePng, height: 30),
                  ],
                ),
                const SizedBox(height: 20),
                const MyText(
                  text: "Please enter email and password to login.",
                  family: AppFonts.semibold,
                  color: AppColors.greyColor,
                ),
                const SizedBox(height: 60),
                Form(
                  key: _keys[0],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.email),
                    type: TextInputType.emailAddress,
                    label: "Email",
                    hint: "Enter Email",
                    controller: _controllers[0],
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
                const SizedBox(height: 20),
                Form(
                  key: _keys[1],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: CustomTextField(
                    prefixIcon: const Icon(Icons.password),
                    controller: _controllers[1],
                    type: TextInputType.visiblePassword,
                    label: "Password",
                    hint: "Enter Password",
                    obsecure: _obsecure,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obsecure = !_obsecure),
                      icon: Icon(
                        _obsecure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.greyColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required Password";
                      }
                      return null;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.forgotPasswordScreen,
                    ),
                    child: const MyText(
                      text: "Forgot Password",
                      color: AppColors.primaryColor,
                      size: AppConstants.subtitle,
                      family: AppFonts.semibold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: "Login",
                    onPressed: loginUser,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const MyText(
                      text: "Don't have an account?",
                      family: AppFonts.semibold,
                      color: AppColors.greyColor,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.signUpScreen,
                      ),
                      child: const MyText(
                        color: AppColors.primaryColor,
                        family: AppFonts.semibold,
                        text: "Sign Up",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Row(
                  children: <Widget>[
                    Expanded(
                        child: Divider(
                      height: 2,
                      color: AppColors.cardColor,
                    )),
                    MyText(
                      text: "  OR  ",
                      family: AppFonts.semibold,
                      color: AppColors.greyColor,
                    ),
                    Expanded(
                        child: Divider(
                      height: 2,
                      color: AppColors.cardColor,
                    )),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: CardButton(
                    onTap: () => loginUser(googleSignin: true),
                    width: size.width * 0.6,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 11,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(AppAssets.googlePng, height: 25),
                        const SizedBox(width: 10),
                        const MyText(
                          text: "Continue With Google",
                          family: AppFonts.semibold,
                        ),
                      ],
                    ),
                  ),
                ),
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
