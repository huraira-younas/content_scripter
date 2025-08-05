import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/common_widget/loading/loading_screen_controller.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'dart:async' show StreamController;
import 'package:flutter/material.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String title,
    required String text,
  }) {
    if ((_controller?.update(text, title) ?? false)) {
      return;
    }
    _controller = _showOverlay(context: context, title: title, text: text);
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
    required String title,
  }) {
    final textStream = StreamController<String>();
    textStream.add(text);
    final titleStream = StreamController<String>();
    titleStream.add(title);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5,
              ),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 16,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _textbuilder(stream: titleStream, isBold: true),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 3,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _textbuilder(
                        stream: textStream,
                        size: AppConstants.subtitle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    state.insert(overlay);
    return LoadingScreenController(
      close: () {
        textStream.close();
        titleStream.close();
        overlay.remove();
        return true;
      },
      update: (text, title) {
        textStream.add(text);
        titleStream.add(title);
        return true;
      },
    );
  }

  StreamBuilder<String> _textbuilder({
    required StreamController<String> stream,
    bool isBold = false,
    double size = AppConstants.titleLarge,
  }) {
    return StreamBuilder(
      stream: stream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Flexible(
            child: MyText(
              text: snapshot.data!,
              size: size,
              family: isBold ? AppFonts.bold : AppFonts.medium,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
