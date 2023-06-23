import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:videodown/infrastructure/themes.dart';
import 'package:videodownloader/videotaskitem.dart';


class LineChartSample extends StatefulWidget {
  const LineChartSample({Key? key, required this.videoTaskItem})
      : super(key: key);
  final VideoTaskItem videoTaskItem;

  @override
  // ignore: library_private_types_in_public_api
  _LineChartSampleState createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  /*List<Color> gradientColors = [
    const Color(0xFFE6233D),
    const Color(0xFFE49C00),
  ];*/

  List<Color> gradientColors = [
    const Color(0xFFAF0058),
    const Color(0xFFE7912F),
  ];

  bool showAvg = false;

  List<double> speedlist = [];
  double temp = 0;
  int random(int min, int max) {
    var rn = Random();
    return min + rn.nextInt(max - min);
  }

  @override
  Widget build(BuildContext context) {
    double? tmp = widget.videoTaskItem.speedDouble();
    // spots.add(FlSpot(spots.length.toDouble(), tmp));
    speedlist.add(tmp ?? 0);
    if (speedlist.length > 100) speedlist.removeAt(0);
    const dur = Duration(seconds: 10);

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 4.5,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            //: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
            child: LineChart(
              mainData(speedlist),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(List<double> speedlist) {
    List<FlSpot> spots = [];
    double maxy = 0;
    double miny = 0;
    for (int i = 0; i < speedlist.length; i++) {
      if (speedlist[i] > maxy) maxy = speedlist[i];
      if (speedlist[i] < miny) miny = speedlist[i];
      spots.add(FlSpot(double.parse(i.toString()), speedlist[i]));
    }

    LineChartBarData lBardata = LineChartBarData(
      //shadow: Shadow(color: Colors.black, blurRadius: 10),
      spots: spots,
      isCurved: true,
      gradient: LinearGradient(colors: gradientColors),
      barWidth: 2,
      isStrokeCapRound: true,
      showingIndicators: [1, 2, 5, 1, 4, 5],
      //gradientFrom: Offset(2, 3),
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList()),
      ),
    );
    return LineChartData(
      //lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: MyColors.opp1.withOpacity(0.05),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: MyColors.opp1.withOpacity(0.05),
            strokeWidth: 1,
          );
        },
      ),
      clipData: FlClipData(top: true, bottom: true, left: true, right: true),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 99,
      minY: miny - (miny / 2),
      maxY: maxy + (maxy / 3),
      showingTooltipIndicators: [
        ShowingTooltipIndicators(
          10 as List<LineBarSpot>,
        )
      ],
      lineBarsData: [lBardata],
    );
  }
}
