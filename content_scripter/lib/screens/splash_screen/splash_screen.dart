import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/snack_error.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/cubits/assistant_cubit.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Completer;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AnimationController _textController;
  late final Animation<Offset> _textAnimation;

  final _completers = List.generate(3, (i) => Completer<void>());
  bool _isError = false;
  var _route = AppRoutes.welcomeScreen;

  void getAssistants() {
    context.read<AssistantCubit>().getData();
    context.read<ChatCubit>().setupModel();
    _isError = false;
  }

  Future<void> changeScreen(String route) async {
    await Future.wait(_completers.map((e) => e.future));
    if (_isError || !mounted) return;

    Navigator.of(context).pushReplacementNamed(route);
  }

  void _throwError() {
    _isError = true;
    const message = "Unable to connect to server";
    showErrorSnack(
      onRetry: getAssistants,
      context: context,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AssistantCubit, AssistantState>(
            listenWhen: (_, c) => !c.loading,
            listener: (context, state) {
              final isEmpty = state.assistants.isEmpty;
              if (isEmpty) {
                _throwError();
                return;
              }
              _completeFuture(2);
            },
          ),
          BlocListener<ChatCubit, ChatState>(
            listenWhen: (_, c) => !c.loading,
            listener: (context, state) {
              if (state.error) {
                _throwError();
                return;
              }
              _completeFuture(1);
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              _route = state.loggedIn
                  ? AppRoutes.routesScreen
                  : AppRoutes.welcomeScreen;
              changeScreen(_route);
              _completeFuture(0);
            },
          ),
        ],
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _animationController,
                child: Hero(
                  tag: "app_logo",
                  child: Image.asset(
                    AppAssets.appLogoPng,
                    height: width * 0.32,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _animationController,
                child: SlideTransition(
                  position: _textAnimation,
                  child: const MyText(
                    text: AppConstants.appname,
                    family: AppFonts.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeFuture(int idx) {
    if (_completers[idx].isCompleted) return;
    _completers[idx].complete();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      lowerBound: 0.4,
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
    _textController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    super.dispose();
  }
}
