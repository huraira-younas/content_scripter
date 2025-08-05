import 'package:content_scripter/screens/membership_screens/widgets/review_tile.dart';
import 'package:content_scripter/common_widget/custom_button.dart';
import 'package:content_scripter/common_widget/custom_appbar.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_utils.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;

class ERecieptScreen extends StatefulWidget {
  const ERecieptScreen({super.key});

  @override
  State<ERecieptScreen> createState() => _ERecieptScreenState();
}

class _ERecieptScreenState extends State<ERecieptScreen> {
  final _screenshotController = ScreenshotController();
  bool _loading = false;

  void _captureAndSave() async {
    setState(() => _loading = true);
    final image = await _screenshotController.capture();
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/e_reciept.png');
      await file.writeAsBytes(image);
      Fluttertoast.showToast(msg: "Reciept Saved Successfully");
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: "E-Reciept"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Screenshot(
              controller: _screenshotController,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.padding + 10,
                ),
                child: Column(
                  // Want to capture this whole column
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    BarcodeWidget(
                      color: AppColors.whiteColor,
                      barcode: Barcode.code128(),
                      data: 'Hello Flutter',
                      drawText: false,
                      height: 80,
                    ),
                    const SizedBox(height: 30),
                    ReviewTile(
                      title: "Plan Details",
                      text: AppUtils.formatMembershipTime(3),
                    ),
                    Divider(
                      color: AppColors.greyColor.withValues(alpha: 0.1),
                      height: 60,
                    ),
                    ReviewTile(
                      title: "Purchase Date",
                      text: formateDate(DateTime.now()),
                    ),
                    const SizedBox(height: 16),
                    ReviewTile(
                      title: "Expire Date",
                      text: formateDate(DateTime.now().add(
                        const Duration(days: 320),
                      )),
                    ),
                    Divider(
                      color: AppColors.greyColor.withValues(alpha: 0.1),
                      height: 60,
                    ),
                    const ReviewTile(title: "Amount", text: "\$69.99"),
                    const SizedBox(height: 16),
                    const ReviewTile(title: "Tax & Fees", text: "\$0.2"),
                    const SizedBox(height: 20),
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: AppColors.greyColor.withValues(alpha: 0.1),
                        radius: Radius.circular(10),
                        dashPattern: const [8, 10],
                        padding: EdgeInsets.zero,
                      ),
                      child: const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),
                    const ReviewTile(title: "Total", text: "\$70.01"),
                    Divider(
                      color: AppColors.greyColor.withValues(alpha: 0.1),
                      height: 60,
                    ),
                    const ReviewTile(title: "Name", text: "Senpai"),
                    const SizedBox(height: 16),
                    const ReviewTile(
                      title: "Phone Number",
                      text: "+923191075382",
                    ),
                    const SizedBox(height: 16),
                    const ReviewTile(
                      title: "Payment Mode",
                      text: "Google Pay",
                    ),
                    const SizedBox(height: 16),
                    const ReviewTile(
                      title: "Transaction ID",
                      text: "#12124197229",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          CustomButton(
            width: MediaQuery.sizeOf(context).width * 0.7,
            isLoading: _loading,
            text: "Download E-Reciept",
            onPressed: _captureAndSave,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

String formateDate(DateTime time) {
  return DateFormat('MMMM d, yyyy | hh:mm a').format(time);
}
