import 'package:content_scripter/screens/history_screen/widgets/empty_widget.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/screens/history_screen/widgets/history_tiles_builder.dart';
import 'package:content_scripter/common_widget/dialog_boxs.dart'
    show confirmDialogue;
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/models/history_model.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/cubits/history_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class DeleteHistoryScreen extends StatefulWidget {
  final String userId;
  const DeleteHistoryScreen({super.key, required this.userId});

  @override
  State<DeleteHistoryScreen> createState() => _DeleteHistoryScreenState();
}

class _DeleteHistoryScreenState extends State<DeleteHistoryScreen> {
  late final _historyCubit = context.read<HistoryCubit>();
  final Set<String> _selectedItems = {};
  List<HistoryModel> _history = [];

  void toggleSelection(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems.add(id);
      }
    });
  }

  void selectAll() {
    setState(() {
      if (_selectedItems.length == _history.length) {
        _selectedItems.clear();
        return;
      }
      for (final i in _history) {
        _selectedItems.add(i.sessionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "Delete History", actions: [
        IconButton(
          onPressed: selectAll,
          icon: Icon(
            _history.length == _selectedItems.length
                ? Icons.remove_done
                : Icons.done_all,
          ),
        ),
        const SizedBox(width: 10),
      ]),
      body: BlocConsumer<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state.error == null && state.loading == null) {
            Fluttertoast.showToast(msg: "History Deleted Successfully");
            _selectedItems.clear();
          }
        },
        builder: (context, state) {
          _history = context.read<HistoryCubit>().getUserHistory(
                widget.userId,
              );

          return Column(
            children: <Widget>[
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _history.isEmpty
                      ? const EmptyWidget()
                      : HistoryTilesBuilder(
                          selected: _selectedItems,
                          onTap: (history) =>
                              toggleSelection(history.sessionId),
                          history: _history,
                          loading: true,
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.padding,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CustomButton(
                        onPressed: () => Navigator.of(context).pop(),
                        borderColor: AppColors.borderColor,
                        bgColor: Colors.transparent,
                        text: "Cancel",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        bgColor: Colors.redAccent,
                        onPressed:
                            _selectedItems.isEmpty ? null : _deleteHistory,
                        text: _getDeleteText(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  String _getDeleteText() {
    String msg = "Delete";
    if (_selectedItems.isEmpty) {
      return msg;
    }
    msg += " ${_selectedItems.length} item";
    msg += (_selectedItems.length > 1 ? "s" : "");
    return msg;
  }

  void _deleteHistory() async {
    final isAll = _selectedItems.length == _history.length;
    if (_history.isEmpty) return;

    final del = await confirmDialogue(
      message: isAll
          ? AppConstants.delHistoryText
          : "Are you sure you want to delete the selected history",
      confirmColor: Colors.redAccent,
      title: "Delete History",
      context: context,
    );
    if (!del) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      _historyCubit.deleteHistory(sids: _selectedItems.toList());
    });
  }
}
