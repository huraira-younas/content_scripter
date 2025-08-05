import 'package:content_scripter/models/trending_search_model.dart';
import 'package:content_scripter/common_widget/text_widget.dart';
import 'package:content_scripter/constants/app_contants.dart';
import 'package:content_scripter/constants/app_colors.dart';
import 'package:content_scripter/constants/app_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatelessWidget {
  final List<InterestData> data;
  final String keyword;
  const CustomLineChart({
    required this.keyword,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat("yyyy").format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MyText(
          text: "Trends of $keyword",
          size: AppConstants.subtitle,
          family: AppFonts.bold,
        ),
        MyText(
          text: "Since 2004 - $date",
          color: AppColors.greyColor,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: LineChart(mainData(data)),
        ),
      ],
    );
  }

  LineChartData mainData(List<InterestData> data) {
    final int xInterval = (data.length / 8).ceil();
    final int yMinValue = data.map((data) => data.value).reduce(
          (a, b) => a < b ? a : b,
        );
    final int yMaxValue = data.map((data) => data.value).reduce(
          (a, b) => a > b ? a : b,
        );

    final int yRange = yMaxValue - yMinValue;
    final int yInterval = (yRange / 10).ceil();

    return LineChartData(
      clipData: const FlClipData.all(),
      backgroundColor: AppColors.cardColor,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppColors.whiteColor.withValues(alpha: 0.05),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: AppColors.whiteColor.withValues(alpha: 0.05),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            interval: xInterval.toDouble(),
            getTitlesWidget: (value, meta) {
              return bottomTitleWidgets(value, meta, data);
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            interval: yInterval.toDouble(),
            reservedSize: 20,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: Border.all(color: AppColors.borderColor),
        show: true,
      ),
      minX: 0,
      maxX: data.length.toDouble() - 1,
      maxY: yMaxValue.toDouble() + 10,
      minY: 0,
      lineBarsData: [
        LineChartBarData(
          spots: data
              .asMap()
              .entries
              .map((entry) => FlSpot(
                    entry.key.toDouble(),
                    entry.value.value.toDouble(),
                  ))
              .toList(),
          isCurved: true,
          gradient: const LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.whiteColor,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.whiteColor,
              ].map((color) => color.withValues(alpha: 0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );
    return Text('${value.toInt()}', style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(
    double value,
    TitleMeta meta,
    List<InterestData> data,
  ) {
    const style = TextStyle(
      color: Colors.white,
      fontSize: 8,
    );
    String text = '';
    if (value.toInt() >= 0 && value.toInt() < data.length) {
      text = data[value.toInt()].time.year.toString();
    }
    return SideTitleWidget(
      meta: meta,
      child: Text(text, style: style),
    );
  }
}
