import 'package:content_scripter/screens/account_screen/help_center_screen/widgets/acordion_builder.dart';
import 'package:content_scripter/screens/account_screen/help_center_screen/widgets/center_btn_builder.dart';
import 'package:content_scripter/models/help_center_model.dart';
import 'package:content_scripter/cubits/help_center_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  final List<FaqModel> faqs;
  const FaqPage({super.key, required this.faqs});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late final _helpCubit = context.read<HelpCenterCubit>();
  late final _pageController = _helpCubit.controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 10),
        CenterBtnBuilder(faqs: widget.faqs),
        const SizedBox(height: 20),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => _helpCubit.navigateTo(value),
            itemCount: widget.faqs.length,
            itemBuilder: (context, index) {
              final faq = widget.faqs[index];
              return AcordionBuilder(faq: faq);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _helpCubit.navigateTo(0);
    super.dispose();
  }
}
