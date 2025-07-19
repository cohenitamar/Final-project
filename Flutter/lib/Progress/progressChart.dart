import 'package:IOFit/Progress/ProgressProvider.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
// import '/flutter_flow/flutter_flow_charts.dart'; // Removed
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart'; // Added
import 'PersonGeneralData.dart';
import 'workoutProgramData.dart';
import '../../bottom_toolbar.dart';
import 'generalProgressListMember.dart';
import 'progressListMember.dart';
import 'ProgressChartProvider.dart';
import 'package:provider/provider.dart';

class ProgressChart extends StatefulWidget {
  const ProgressChart({
    super.key,
    required this.exercise,
    required this.value,
    required this.clicked,
  });

  final String exercise;
  final int value;
  final String clicked;

  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final chartProvider = Provider.of<ProgressChartProvider>(context, listen: true);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    chartProvider.initializeData(widget.exercise, widget.clicked,progressProvider.progressData);
    return Align(
      alignment: AlignmentDirectional.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 0,top:20,right: 25,bottom: 4),
        child: Column(
          children: [

            SizedBox(
              width: double.infinity, // התאמה לרוחב המסך
              height: 350.0, // הגדלת גובה הגרף
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.transparent,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: 1,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.white54.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.white54.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: Text(
                          'Dates',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0, // הקטנת גודל הכותרת
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      axisNameSize: 30.0,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30.0, // הגדלת מרווח לתוויות
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value.toInt() < 0 || value.toInt() >= chartProvider.xData.length) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              chartProvider.xData[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12, // הקטנת גודל התוויות
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Padding(
                        padding: const EdgeInsets.only(right: 1.0),
                        child: Text(
                          "Weights",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.0, // הקטנת גודל הכותרת
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      axisNameSize: 25.0,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 25.0, // הגדלת reservedSize לתוויות
                        interval: 2,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11, // הקטנת גודל התוויות
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: (chartProvider.xData.length - 1).toDouble(),
                  minY: chartProvider.minYVal,
                  maxY: chartProvider.maxYVal,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        chartProvider.yData.length,
                            (index) =>
                            FlSpot(index.toDouble(), chartProvider.yData[index].toDouble()),
                      ),
                      isCurved: false,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE67E22), // כתום
                          Color(0xFFFFA500), // כתום בהיר יותר
                        ],
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true, // הצגת נקודות נתונים
                         // גודל הנקודות
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFE67E22).withOpacity(0.3),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.black54,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          int index = touchedSpot.x.toInt();
                          String date = chartProvider.xData[index];
                          int weight = chartProvider.yData[index];
                          return LineTooltipItem(
                            '$date: $weight',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            // כותרת לציר ה-Y כבר מוספת בתוך titlesData
          ],
        ),
      ),
    );
  }
}
