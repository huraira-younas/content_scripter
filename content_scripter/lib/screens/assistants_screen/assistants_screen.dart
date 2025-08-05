import 'package:content_scripter/screens/assistants_screen/widgets/tab_buttons.dart';
import 'package:content_scripter/screens/assistants_screen/widgets/tab_cards.dart';
import 'package:content_scripter/cubits/assistant_cubit.dart';
import 'package:content_scripter/constants/exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantsScreen extends StatefulWidget {
  const AssistantsScreen({super.key});

  @override
  State<AssistantsScreen> createState() => _AssistantsScreenState();
}

class _AssistantsScreenState extends State<AssistantsScreen> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssistantCubit, AssistantState>(
      builder: (context, state) {
        final keys = <String>["All", ...state.tabs];
        final assistants = state.assistants;
        return Column(
          children: [
            const SizedBox(height: 10),
            TabsBuilder(
              currentTab: state.filter,
              tabs: keys,
              onTap: (tab) {
                final idx = keys.indexOf(tab);
                pageController.jumpToPage(idx);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: PageView.builder(
                itemCount: keys.length,
                controller: pageController,
                onPageChanged: (value) {
                  context.read<AssistantCubit>().filterAssistants(
                        filter: keys[value],
                      );
                },
                itemBuilder: (context, index) => SingleChildScrollView(
                  key: UniqueKey(),
                  padding: const EdgeInsets.all(AppConstants.padding),
                  child: AssistantBuilder(assistants: assistants),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void deactivate() {
    context.read<AssistantCubit>().filterAssistants(
          filter: "All",
        );
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    context.read<AssistantCubit>().getData();
  }
}
