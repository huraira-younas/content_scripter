import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/cubits/help_center_cubit.dart';
import 'package:content_scripter/cubits/on_boarding_cubit.dart';
import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/cubits/interest_cubit.dart';
import 'package:content_scripter/cubits/timer_cubit.dart';
import 'package:flutter/services.dart'
    show SystemChrome, DeviceOrientation, SystemUiOverlayStyle;
import 'package:content_scripter/cubits/navigation_cubit.dart';
import 'package:content_scripter/cubits/assistant_cubit.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/cubits/internet_cubit.dart';

import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/cubits/history_cubit.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:content_scripter/cubits/stt_cubit.dart';
import 'package:content_scripter/cubits/tts_cubit.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  await initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    preloadImages(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SttCubit()),
        BlocProvider(create: (_) => TimerCubit()),
        BlocProvider(create: (_) => HistoryCubit()),
        BlocProvider(create: (_) => InternetCubit()),
        BlocProvider(create: (_) => OnBoardingCubit()),
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(lazy: false, create: (_) => TtsCubit()),
        BlocProvider(lazy: false, create: (_) => ChatCubit()),
        BlocProvider(lazy: false, create: (_) => InterestCubit()),
        BlocProvider(lazy: false, create: (_) => AssistantCubit()),
        BlocProvider(lazy: false, create: (_) => HelpCenterCubit()),
        BlocProvider(lazy: false, create: (_) => MembershipCubit()),
        BlocProvider(
          lazy: false,
          create: (_) => UserBloc()..add(SharedPrefEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appname,
        theme: AppColors.colorTheme,
        onGenerateRoute: (settings) => AppRoutes.onGenerateRoute(settings),
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}

Future<void> preloadImages(BuildContext context) async {
  final List<String> imagePaths = [
    AppAssets.activeAssistantsPng,
    AppAssets.activeAccountPng,
    AppAssets.activeHistoryPng,
    AppAssets.activeChatPng,
    AppAssets.assistantsPng,
    AppAssets.interestsPng,
    AppAssets.historyPng,
    AppAssets.welcomePng,
    AppAssets.accountPng,
    AppAssets.googlePng,
    AppAssets.emptyPng,
    AppAssets.lockPng,
    AppAssets.chatPng,
  ];
  await Future.wait(imagePaths.map((imagePath) => precacheImage(
        AssetImage(imagePath),
        context,
      )));
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}
