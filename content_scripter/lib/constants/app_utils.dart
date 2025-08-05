import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timezone/timezone.dart' as tz;

class AppUtils {
  static String formatCurrency(
    double amount, {
    String symbol = "",
    int decimal = 4,
  }) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: symbol,
      decimalDigits: decimal,
    );
    return currencyFormatter.format(amount);
  }

  static String formatViews(int views) {
    if (views < 1000) {
      return views.toString();
    } else if (views < 1000000) {
      double result = views / 1000.0;
      return '${result.toStringAsFixed(0)}K';
    } else if (views < 1000000000) {
      double result = views / 1000000.0;
      return '${result.toStringAsFixed(0)}M';
    } else {
      double result = views / 1000000000.0;
      return '${result.toStringAsFixed(0)}B';
    }
  }

  static String formatMembershipTime(int days) {
    if (days == 1) {
      return 'For Day';
    }
    if (days % 365 == 0) {
      return 'For ${days ~/ 365} Year${days ~/ 365 == 1 ? '' : 's'}';
    }
    if (days % 30 == 0) {
      return 'For ${days ~/ 30} Month${days ~/ 30 == 1 ? '' : 's'}';
    }
    if (days % 7 == 0) {
      return 'For ${days ~/ 7} Week${days ~/ 7 == 1 ? '' : 's'}';
    }
    return '$days Days';
  }

  static String formatTimeDuration(int value) {
    if (value < 0) return "00:00";

    final years = value ~/ 31104000;
    final months = (value ~/ 2592000) % 12;
    final days = (value ~/ 86400) % 30;
    final remainingHours = (value ~/ 3600) % 24;
    final remainingMinutes = (value ~/ 60) % 60;
    final remainingSeconds = value % 60;

    String durationString = '';

    if (years > 0) {
      durationString += '${years}y ';
    }

    if (months > 0) {
      durationString += '${months}m ';
    }

    if (days > 0) {
      durationString += '${days}d ';
    }

    if (remainingHours > 0) {
      durationString += '${remainingHours}h ';
    }

    final twoDigitMinutes = remainingMinutes.toString().padLeft(2, '0');
    final twoDigitSeconds = remainingSeconds.toString().padLeft(2, '0');

    durationString += '$twoDigitMinutes:$twoDigitSeconds';

    return durationString;
  }

  static String formatDateTime(DateTime dateTime) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      // Today's date
      return 'Today ${DateFormat('hh:mm a').format(dateTime)}';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      // Yesterday's date
      return 'Yesterday ${DateFormat('hh:mm a').format(dateTime)}';
    } else {
      // A date before yesterday
      return DateFormat('MMM d, yyyy hh:mm a').format(dateTime);
    }
  }

  static String formatDate(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  static String formatTimeAgo(DateTime timeStamp) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime postDateTime = tz.TZDateTime.from(
      timeStamp,
      tz.getLocation(tz.local.name),
    );

    final difference = now.difference(postDateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes}m ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours}h ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}d ago";
    } else {
      return DateFormat.yMMMMd().format(postDateTime);
    }
  }

  static bool isEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z]{2,})+$",
    );

    return emailRegex.hasMatch(email);
  }

  static Future<XFile?> pickImage({required bool isCamera}) async {
    try {
      return await ImagePicker().pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 20,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> launchURL(String url) async {
    if (url.trim().isEmpty) return;

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      Fluttertoast.showToast(msg: "Network Error");
    }
  }

  static String removeSpecialCharacters(String input) {
    final regExp = RegExp(r'[^\w\s.,:]');
    return input.replaceAll(regExp, '');
  }
}
