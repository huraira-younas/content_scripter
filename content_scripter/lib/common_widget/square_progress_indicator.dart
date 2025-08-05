import 'package:content_scripter/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class SquareProgressIndicator extends StatelessWidget {
  final double progress;
  const SquareProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SquareProgressPainter(
        progress: progress,
        borderRadius: 10,
      ),
    );
  }
}

class SquareProgressPainter extends CustomPainter {
  final double borderRadius;
  final double progress;

  SquareProgressPainter({
    required this.progress,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Color color = AppColors.primaryColor;
    if (progress > 85) {
      color = Colors.redAccent;
    } else if (progress >= 60) {
      color = Colors.amber;
    }

    final paint = Paint()
      ..color = AppColors.borderColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, paint);

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width - borderRadius, 0)
      ..arcToPoint(
        Offset(size.width, borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(size.width, size.height - borderRadius)
      ..arcToPoint(
        Offset(size.width - borderRadius, size.height),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(borderRadius, size.height)
      ..arcToPoint(
        Offset(0, size.height - borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(0, borderRadius)
      ..arcToPoint(
        Offset(borderRadius, 0),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(size.width / 2, 0);

    final ui.PathMetric pathMetric = path.computeMetrics().first;
    final double progressLength = pathMetric.length * progress / 100;

    final progressPath = pathMetric.extractPath(0, progressLength);
    canvas.drawPath(progressPath, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
