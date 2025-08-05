import 'package:content_scripter/screens/account_screen/widgets/sections_builder.dart';
import 'package:content_scripter/screens/account_screen/widgets/user_tile.dart';
import 'package:content_scripter/screens/account_screen/premium_tile.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show confirmDialogue;
import 'package:content_scripter/constants/app_contants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void logout() => confirmDialogue(
          message: "Are you sure you want to log out?",
          context: context,
          title: "Logout",
        ).then((choice) {
          if (!choice || !context.mounted) return;
          context.read<UserBloc>().add(LogoutEvent());
        });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.padding),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final user = state.user!;
          return Column(
            children: <Widget>[
              UserTile(
                user: user,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.personalInfoScreen,
                  arguments: user,
                ),
              ),
              const SizedBox(height: 10),
              PremiumTile(user: user),
              const SizedBox(height: 30),
              SectionsBuilder(logout: logout, user: user),
            ],
          );
        },
      ),
    );
  }
}
