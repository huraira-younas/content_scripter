import 'package:content_scripter/screens/membership_screens/widgets/subscriptions_sheet.dart';
import 'package:content_scripter/screens/membership_screens/widgets/membership_card.dart';
import 'package:content_scripter/screens/membership_screens/review_summary_screen.dart';
import 'package:content_scripter/models/membership_model/feature_settings_model.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show errorDialogue;
import 'package:content_scripter/common_widget/loading/loading_screen.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/common_widget/ui_loader.dart';
import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  late final _membershipCubit = context.read<MembershipCubit>();
  late final _user = context.read<UserBloc>().user!;
  final Map<int, MembershipPricing> _pricing = {};
  final _loader = LoadingScreen.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "Choose Your Tier"),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: AppColors.primaryColor,
        onRefresh: () => fetchMemberships(refresh: true),
        child: BlocConsumer<MembershipCubit, MembershipState>(
          listener: (context, state) {
            _loader.hide();
            if (state.error != null &&
                state.error!.type == MemErrorType.normal) {
              final error = state.error!;
              errorDialogue(
                message: error.message,
                title: error.title,
                context: context,
              );
            } else if (state.loading) {
              const message = "Please wait...";
              switch (state.action) {
                case MembershipAction.cancel:
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
            if (_pricing.isEmpty) {
              setPricing(state.memberships);
            }
          },
          builder: (context, state) {
            final memberships = state.memberships;
            final periods = state.periods;

            if (memberships.isEmpty || state.loading) {
              return const Center(child: UILoader());
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppConstants.padding),
              itemCount: memberships.length,
              separatorBuilder: (__, _) => const SizedBox(height: 20),
              itemBuilder: (_, idx) {
                final membership = memberships[idx];
                final isCurrent = _user.membershipId == membership.id;
                final price = _pricing[idx] ??
                    MembershipPricing(
                      amount: membership.price * 30,
                      days: 30,
                    );

                return MembershipCard(
                  key: UniqueKey(),
                  isCurrent: isCurrent,
                  membership: membership,
                  price: price,
                  onSelectPlan: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReviewSummaryScreen(
                        membership: membership,
                        price: price,
                      ),
                    ),
                  ),
                  onSubTap: () => showSubscription(
                    membership: membership,
                    onTap: (subs) {
                      setState(() {
                        _pricing[idx] = MembershipPricing(
                          amount: subs * membership.price,
                          days: subs,
                        );
                      });
                    },
                    periods: periods,
                    context: context,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMemberships();
  }

  Future<void> fetchMemberships({bool refresh = false}) async =>
      await _membershipCubit.getAllMemberships(
        isRefresh: refresh,
      );

  void setPricing(List memberships) {
    memberships.asMap().forEach((idx, membership) {
      _pricing.putIfAbsent(
        idx,
        () => MembershipPricing(
          amount: 30.0 * membership.price,
          days: 30,
        ),
      );
    });
    setState(() {});
  }
}
