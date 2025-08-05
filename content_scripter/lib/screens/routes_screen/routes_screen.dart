import 'package:content_scripter/screens/routes_screen/widgets/network_status.dart';
import 'package:content_scripter/screens/routes_screen/widgets/custom_navbar.dart';
import 'package:content_scripter/screens/assistants_screen/assistants_screen.dart';
import 'package:content_scripter/screens/interests_screen/interests_screen.dart';
import 'package:content_scripter/screens/account_screen/account_screen.dart';
import 'package:content_scripter/screens/history_screen/history_screen.dart';
import 'package:flutter/services.dart' show HapticFeedback, SystemNavigator;
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/screens/chat_screen/chat_screen.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show errorDialogue, confirmDialogue;
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/cubits/navigation_cubit.dart';
import 'package:content_scripter/cubits/history_cubit.dart';
import 'package:content_scripter/cubits/timer_cubit.dart';
import 'package:content_scripter/cubits/chat_cubit.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  late final _navigator = BlocProvider.of<NavigationCubit>(context);
  final _loader = LoadingScreen.instance();
  bool _mutax = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, index) {
        return PopScope(
          canPop: index == 0,
          onPopInvokedWithResult: (_, didPop) async {
            if (index != 0) {
              _navigator.navigateTo(0);
            } else {
              bool confirm = await confirmDialogue(
                context: context,
                title: "Exit",
                message: "Do you want to exit?",
              );
              if (confirm) {
                SystemNavigator.pop();
              }
            }
          },
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) async {
              _loader.hide();
              if (state.loading != null) {
                final loading = state.loading!;
                _loader.show(
                  context: context,
                  title: loading.title,
                  text: loading.message,
                );
              } else if (!state.loggedIn) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.loginScreen,
                  (route) => false,
                );
              } else if (state.error != null) {
                if (_mutax) return;
                _mutax = true;
                final error = state.error!;
                await errorDialogue(
                  context: context,
                  title: error.title,
                  message: error.message,
                );
                _mutax = false;
              }
            },
            child: Scaffold(
              appBar: customAppBar(
                context: context,
                title: appbars[index],
                back: index != 0,
                actions: getActionList(index),
                onBackPress: () {
                  HapticFeedback.vibrate();
                  _navigator.navigateTo(0);
                },
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _screens[index],
              ),
              bottomNavigationBar: CustomNavbar(
                index: index,
                onNavigate: (idx) {
                  HapticFeedback.vibrate();
                  _navigator.navigateTo(idx);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  final _screens = [
    const ChatScreen(),
    const AssistantsScreen(),
    const InterestsScreen(),
    const HistoryScreen(),
    const AccountScreen(),
  ];

  final appbars = [
    "AI Content Scripter",
    "Assistants",
    "Interests",
    "Activity",
    "Account",
  ];

  List<Widget> getActionList(int index) {
    return index == 3
        ? [
            const NetworkStatus(),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.searchScreen,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.deleteHistoryScreen,
                arguments: context.read<UserBloc>().user!.uid,
              ),
            ),
          ]
        : [const NetworkStatus(), const SizedBox(width: 10)];
  }

  @override
  void deactivate() {
    _navigator.navigateTo(0);
    context.read<HistoryCubit>().reset();
    context.read<TimerCubit>().reset();
    context.read<ChatCubit>().reset();
    super.deactivate();
  }
}
