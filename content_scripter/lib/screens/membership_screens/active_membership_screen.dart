import 'package:content_scripter/models/membership_model/membership_model.dart';
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:content_scripter/cubits/timer_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';

class ActiveMembershipScreen extends StatefulWidget {
  final String memId;
  const ActiveMembershipScreen({super.key, required this.memId});

  @override
  State<ActiveMembershipScreen> createState() => _ActiveMembershipScreenState();
}

class _ActiveMembershipScreenState extends State<ActiveMembershipScreen> {
  late final _membershipBloc = context.read<MembershipCubit>();
  final _loader = LoadingScreen.instance();
  late final MembershipModel _membership;
  bool isCancel = false;

  void cancelMembership() async {
    final userBloc = context.read<UserBloc>();
    final user = userBloc.user!;

    final confirm = await confirmDialogue(
      context: context,
      title: "Membership Cancellation",
      message: "Do you really want to cancel your current plan?",
      actions: {"cancel": "No", "confirm": "Confirm"},
    );

    if (!confirm) return;
    _membershipBloc.cancelMembership(userId: user.uid);
  }

  void revertMembership() {
    context.read<TimerCubit>().reset();
    final membership = _membershipBloc.freeMembership;
    final userBloc = context.read<UserBloc>();
    userBloc.add(SetUserEvent(
      user: userBloc.user!.copyWith(membershipId: membership.id),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "Membership"),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: BlocListener<MembershipCubit, MembershipState>(
          listener: (context, state) {
            _loader.hide();
            if (state.loading) {
              const message = "Please wait...";
              switch (state.action) {
                case MembershipAction.cancel:
                  isCancel = true;
                  _loader.show(
                    context: context,
                    title: "Cancelling Membership",
                    text: message,
                  );
                  break;
                case MembershipAction.purchase:
                  _loader.show(
                    context: context,
                    title: "Purchasing Membership",
                    text: message,
                  );
                  break;
                case MembershipAction.upgrade:
                  _loader.show(
                    context: context,
                    title: "Upgrading Membership",
                    text: message,
                  );
                  break;
                default:
                  break;
              }
            }
            if (state.error == null &&
                !state.loading &&
                state.action == MembershipAction.cancel) {
              revertMembership();
              Navigator.of(context).popUntil(
                (route) => route.settings.name == AppRoutes.routesScreen,
              );
            }
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                        left: BorderSide(
                          color: AppColors.primaryColor,
                          width: 10,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            color: Colors.white,
                            AppAssets.crown,
                            height: 38,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            MyText(
                              color: Colors.white,
                              text: _membership.title,
                              size: AppConstants.title,
                              family: AppFonts.semibold,
                            ),
                            MyText(
                              text:
                                  "USD ${AppUtils.formatCurrency(_membership.price, decimal: 2)}/mo",
                              size: AppConstants.subtitle,
                              color: AppColors.greyColor,
                            ),
                            const MyText(
                              text: "Expiry: May 25, 2025",
                              size: AppConstants.subtitle,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    right: 10,
                    top: 10,
                    child: MyText(
                      text: "Active",
                      color: Colors.green,
                      size: AppConstants.subtitle,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomButton(
                      text: "Upgrade",
                      textColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
                      bgColor: Colors.transparent,
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.membershipScreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      text: "Cancel",
                      bgColor: Colors.redAccent,
                      onPressed: cancelMembership,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final memberships = context.read<MembershipCubit>().memberships;
    _membership = memberships.firstWhere((e) => e.id == widget.memId);
  }
}
