import 'package:content_scripter/screens/account_screen/help_center_screen/widgets/acordion_builder.dart';
import 'package:content_scripter/models/help_center_model.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  final List<ContactUsModel> contactUs;
  const ContactUsPage({super.key, required this.contactUs});

  @override
  Widget build(BuildContext context) {
    void launchURL(String socialLink) async {
      if (await canLaunchUrlString(socialLink)) {
        await launchUrlString(socialLink);
      } else {
        Fluttertoast.showToast(msg: "Unable to launch url");
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.padding,
          0,
          AppConstants.padding,
          AppConstants.padding + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            contactUs.length,
            (index) => AccordionCard(
              isFirst: index == 0,
              item: contactUs[index],
              onTap: () => launchURL(contactUs[index].text),
              leading: contactUs[index].icon,
            ),
          ),
        ),
      ),
    );
  }
}
