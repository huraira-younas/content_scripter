import 'package:content_scripter/screens/account_screen/help_center_screen/help_center_screen.dart';
import 'package:content_scripter/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:content_scripter/screens/membership_screens/active_membership_screen.dart';
import 'package:content_scripter/screens/forgot_password_screen/create_new_screen.dart';
import 'package:content_scripter/screens/forgot_password_screen/verify_otp_screen.dart';
import 'package:content_scripter/screens/history_screen/delete_history_screen.dart';
import 'package:content_scripter/screens/membership_screens/e_reciept_screen.dart';
import 'package:content_scripter/screens/membership_screens/membership_screen.dart';
import 'package:content_scripter/screens/account_screen/personal_info_screen.dart';
import 'package:content_scripter/screens/chat_screen/start_chatting_screen.dart';
import 'package:content_scripter/screens/account_screen/password_manager.dart';
import 'package:content_scripter/common_widget/custom_routes/bottom_top.dart';
import 'package:content_scripter/screens/splash_screen/welcome_screen.dart';
import 'package:content_scripter/screens/history_screen/search_screen.dart';
import 'package:content_scripter/screens/routes_screen/routes_screen.dart';
import 'package:content_scripter/screens/splash_screen/splash_screen.dart';
import 'package:content_scripter/screens/account_screen/html_screen.dart';
import 'package:content_scripter/screens/auth_screen/signup_screen.dart';
import 'package:content_scripter/screens/auth_screen/login_screen.dart';
import 'package:content_scripter/blocs/timer_bloc/timer_bloc.dart';
import 'package:content_scripter/models/user_model.dart';
import 'package:content_scripter/cubits/otp_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart'
    show Route, RouteSettings, MaterialPageRoute;

class AppRoutes {
  static const splashScreen = '/';
  static const homeScreen = '/home';
  static const searchScreen = '/search';
  static const routesScreen = '/routes';
  static const welcomeScreen = '/welcome';

  // Auth Screens
  static const loginScreen = '/login';
  static const signUpScreen = '/signUp';

  static const verifyOtpScreen = '/verifyOtp';
  static const forgotPasswordScreen = '/forgotPassword';
  static const createNewPasswordScreen = '/createNewPassword';

  static const activeMembershipScreen = '/active_membership';
  static const startChattingScreen = '/startChatting';
  static const deleteHistoryScreen = '/deleteHistory';
  static const personalInfoScreen = '/personalInfo';
  static const membershipScreen = '/membership';
  static const eRecieptScreen = '/e_reciept';

  static const helpCenterScreen = '/help_center';
  static const privacyPolicyScreen = '/privacy_policy';
  static const termAndServicesScreen = '/term_services';
  static const passwordManagerScreen = '/password_manager';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String? routeName = settings.name;

    switch (routeName) {
      case splashScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const SplashScreen(),
        );
      case routesScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const RoutesScreen(),
        );
      case searchScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const SearchScreen(),
        );
      case deleteHistoryScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => DeleteHistoryScreen(
            userId: settings.arguments as String,
          ),
        );
      case startChattingScreen:
        final data = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => StartChatScreen(
            assistant: data['assistant'],
            prompt: data['prompt'],
            title: data['title'],
            sid: data['sid'],
          ),
        );
      case membershipScreen:
        return BottomToTopRoute(
          duration: const Duration(seconds: 1),
          page: const MembershipScreen(),
        );
      case activeMembershipScreen:
        final memId = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => ActiveMembershipScreen(memId: memId),
        );
      case eRecieptScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ERecieptScreen(),
        );
      case welcomeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const WelcomeScreen(),
        );
      case helpCenterScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HelpCenterScreen(),
        );
      case privacyPolicyScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HTMLScreen(stx: 1),
        );
      case termAndServicesScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const HTMLScreen(stx: 2),
        );
      case passwordManagerScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const PasswordManagerScreen(),
        );
      case personalInfoScreen:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<TimerBloc>(create: (context) => TimerBloc()),
              BlocProvider<OtpCubit>(create: (context) => OtpCubit()),
            ],
            child: PersonalInfoScreen(user: user),
          ),
        );
      case loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const LoginScreen(),
        );
      case forgotPasswordScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => OtpCubit(),
            child: const ForgotPasswordScreen(),
          ),
        );
      case verifyOtpScreen:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<TimerBloc>(
                create: (context) => TimerBloc()..add(StartTimer(duration: 60)),
              ),
              BlocProvider<OtpCubit>(create: (context) => OtpCubit()),
            ],
            child: VerifyOtpScreen(email: email),
          ),
        );
      case createNewPasswordScreen:
        final email = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => CreateNewPassword(email: email),
        );
      case signUpScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<TimerBloc>(create: (context) => TimerBloc()),
              BlocProvider<OtpCubit>(create: (context) => OtpCubit()),
            ],
            child: const SignUpScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const LoginScreen(),
        );
    }
  }
}
