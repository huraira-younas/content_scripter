import 'package:content_scripter/screens/account_screen/help_center_screen/contact_us_page.dart';
import 'package:content_scripter/screens/account_screen/help_center_screen/faq_page.dart';
import 'package:content_scripter/common_widget/custom_tabbar.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/cubits/help_center_cubit.dart';
import 'package:content_scripter/models/help_center_model.dart';
import 'package:content_scripter/common_widget/text_field.dart';
import 'package:content_scripter/common_widget/ui_loader.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  late final _helpCenterCubit = context.read<HelpCenterCubit>();
  final _controller = TextEditingController();
  late final TabController _tabController;
  final _tabs = ["FAQ", "Contact Us"];
  bool _isClear = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "Help Center"),
      body: BlocBuilder<HelpCenterCubit, HelpCenterState>(
        builder: (context, state) {
          if (state.error != null) {
            final error = state.error!;
            return UIError(
              message: error.message,
              onRetry: () => _helpCenterCubit.getData(),
            );
          }

          if (state.loading || state.helpCenter == null) {
            return const Center(child: UILoader());
          }
          final faq = deepSearchFaq(state.helpCenter!.faq);
          final contactUs = state.helpCenter!.contactUs;

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.padding,
                  vertical: 5,
                ),
                child: CustomTextField(
                  hint: "Search...",
                  label: "Search",
                  controller: _controller,
                  onChange: handleSearch,
                  suffixIcon: _isClear
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            toggleClear();
                          },
                          icon: const Icon(Icons.close),
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search, size: 28),
                ),
              ),
              const SizedBox(height: 10),
              CustomTabBar(
                controller: _tabController,
                tabs: _tabs,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    FaqPage(faqs: faq),
                    ContactUsPage(contactUs: contactUs),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<FaqModel> deepSearchFaq(List<FaqModel> faqs) {
    final String query = _controller.text.trim().toLowerCase();
    if (query.isEmpty || faqs.isEmpty) return faqs;

    return faqs.map((allFaqs) {
      final filteredItems = allFaqs.items
          .where((helper) =>
              helper.title.toLowerCase().contains(query) ||
              helper.text.toLowerCase().contains(query))
          .toList();
      return FaqModel(
        catName: allFaqs.catName,
        items: filteredItems,
      );
    }).toList();
  }

  void handleSearch(String? query) {
    if ((query == null || query.isEmpty) && _isClear) {
      toggleClear();
      return;
    } else if (query != null && query.isNotEmpty && !_isClear) {
      _isClear = true;
    }
    context.read<HelpCenterCubit>().navigateTo(0, jump: true);
    if (mounted) setState(() {});
  }

  void toggleClear() {
    if (mounted) setState(() => _isClear = !_isClear);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _helpCenterCubit.getData();
  }

  @override
  void dispose() {
    _helpCenterCubit.navigateTo(0, jump: true);
    _controller.dispose();
    super.dispose();
  }
}
