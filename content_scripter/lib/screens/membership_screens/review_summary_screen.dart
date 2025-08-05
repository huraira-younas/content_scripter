import 'package:content_scripter/screens/membership_screens/widgets/membership_card.dart';
import 'package:content_scripter/screens/membership_screens/widgets/review_tile.dart';
import 'package:content_scripter/screens/membership_screens/success_screen.dart';
import 'package:content_scripter/models/membership_model/exports.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/blocs/user_bloc/user_bloc.dart';
import 'package:content_scripter/cubits/membership_cubit.dart';
import 'package:content_scripter/cubits/timer_cubit.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewSummaryScreen extends StatefulWidget {
  final MembershipModel membership;
  final MembershipPricing price;
  const ReviewSummaryScreen({
    super.key,
    required this.price,
    required this.membership,
  });

  @override
  State<ReviewSummaryScreen> createState() => _ReviewSummaryScreenState();
}

class _ReviewSummaryScreenState extends State<ReviewSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "Review Summary"),
      body: BlocListener<MembershipCubit, MembershipState>(
        listener: (context, state) {
          if (state.error == null && !state.loading) {
            context.read<TimerCubit>().reset();
            final userBloc = context.read<UserBloc>();
            userBloc.add(SetUserEvent(
              user: userBloc.user!.copyWith(membershipId: widget.membership.id),
            ));
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => SuccessScreen(days: widget.price.days),
            ));
          }
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppConstants.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MembershipCard(
                    isReview: true,
                    isCurrent: false,
                    price: widget.price,
                    membership: widget.membership,
                  ),
                  const SizedBox(height: 30),
                  ReviewTile(
                    title: "Amount",
                    text: AppUtils.formatCurrency(
                      widget.price.amount,
                      decimal: 2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const ReviewTile(title: "Tax & Fees", text: "\$0.2"),
                  const SizedBox(height: 30),
                  DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: AppColors.greyColor.withValues(alpha: 0.1),
                      radius: Radius.circular(10),
                      dashPattern: const [8, 8],
                      padding: EdgeInsets.zero,
                    ),
                    child: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  ReviewTile(
                    title: "Total",
                    text: AppUtils.formatCurrency(
                      widget.price.amount + 0.2,
                      decimal: 2,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              width: MediaQuery.sizeOf(context).width * 0.7,
              text: "Confirm Payment",
              onPressed: onGooglePayPressed,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void onGooglePayPressed() async {
    final memBloc = context.read<MembershipCubit>();
    final userBloc = context.read<UserBloc>();
    final user = userBloc.user!;
    final mode =
        memBloc.memberships.firstWhere((e) => e.id == user.membershipId).price >
                0
            ? "upgrade"
            : "subscription";

    memBloc.purchaseMembership(
      memId: widget.membership.id,
      period: widget.price.days,
      trxId: user.email,
      userId: user.uid,
      taxAndFees: 0.4,
      mode: mode,
    );
  }
}
