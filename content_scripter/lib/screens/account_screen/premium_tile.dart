import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_assets.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:content_scripter/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:content_scripter/routes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PremiumTile extends StatelessWidget {
  final UserModel user;
  const PremiumTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    void refresh() => context.read<MembershipCubit>().getAllMemberships();

    return BlocBuilder<MembershipCubit, MembershipState>(
      builder: (context, state) {
        final loading = state.loading;
        final isError =
            state.error != null && state.error!.type != MemErrorType.normal;

        final memberships = state.memberships.where(
          (m) => m.id == user.membershipId,
        );

        final mem = memberships.isEmpty ? null : memberships.first;
        final paid = mem != null && mem.price > 0;

        return GestureDetector(
          onTap: () {
            if (mem == null || isError) {
              refresh();
              return;
            }
            final nav = Navigator.of(context);
            if (paid) {
              nav.pushNamed(
                AppRoutes.activeMembershipScreen,
                arguments: user.membershipId,
              );
              return;
            }
            nav.pushNamed(AppRoutes.membershipScreen);
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: loading
                ? Shimmer.fromColors(
                    highlightColor: AppColors.shimmerHColor,
                    baseColor: AppColors.shimmerBColor,
                    enabled: loading,
                    child: const MembershipTile(loading: true),
                  )
                : MembershipTile(
                    paid: paid,
                    isError: isError,
                    loading: loading,
                  ),
          ),
        );
      },
    );
  }
}

class MembershipTile extends StatelessWidget {
  final bool paid;
  final bool loading;
  final bool isError;
  const MembershipTile({
    super.key,
    this.paid = false,
    this.loading = true,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.only(
        top: 10,
        left: 18,
        right: 20,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: isError
            ? Colors.redAccent
            : !paid
                ? AppColors.cardColor
                : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isError
              ? Colors.red
              : !paid
                  ? AppColors.cardColor
                  : AppColors.primaryColor,
        ),
      ),
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isError
                  ? Colors.redAccent
                  : !paid
                      ? AppColors.primaryColor
                      : const Color(0xFFFAE83E),
            ),
            padding: const EdgeInsets.all(10),
            child: isError
                ? const Icon(
                    Icons.error_outline,
                    color: AppColors.whiteColor,
                    size: 30,
                  )
                : Image.asset(
                    AppAssets.crown,
                    height: 30,
                    color: !paid ? Colors.white : Colors.black,
                  ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyText(
                text: isError
                    ? "Error"
                    : paid
                        ? "View Membership"
                        : "Get Premium Plan",
                size: AppConstants.title,
                family: AppFonts.semibold,
                color: !paid ? AppColors.whiteColor : Colors.white,
              ),
              MyText(
                text: loading
                    ? "loading..."
                    : isError
                        ? "Refresh again"
                        : paid
                            ? "View, upgrade, cancel"
                            : "Click to check details",
                size: AppConstants.subtitle,
                color: !paid ? AppColors.greyColor : Colors.white,
              ),
            ],
          ),
          const Spacer(),
          Icon(
            isError ? Icons.refresh : Icons.chevron_right,
            color: !paid ? AppColors.greyColor : Colors.white,
          ),
        ],
      ),
    );
  }
}
