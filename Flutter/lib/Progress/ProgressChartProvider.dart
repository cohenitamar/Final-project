import 'package:flutter/material.dart';
import 'workoutProgramData.dart';

class ProgressChartProvider with ChangeNotifier {

  String? _exercise;
  List<int> _yData = [];
  List<String> _xData = [];
  double minYVal = 0;
  double maxYVal = 0;

  String? get exercise => _exercise;

  List<String> get xData => _xData;

  List<int> get yData => _yData;


  void reset() {
    _exercise = null;
    _yData = [];
    _xData = [];
    minYVal = 0;
    maxYVal = 0;
    notifyListeners();
  }


  void initializeMaxVals() {
    maxYVal = yData.isNotEmpty
        ? yData.reduce((a, b) => a > b ? a : b).toDouble() + 2
        : 10.0;
    minYVal = yData.isNotEmpty
        ? yData.reduce((a, b) => a < b ? a : b).toDouble() + -7
        : 0.0;
    if (minYVal < 0) {
      minYVal = 0;
    }
  }

  void initializeData(String exc, String clicked,List<WorkoutProgramData> list) {
    _exercise = exc;
    switch (clicked) {
      case '1W':
        WeeklyDate weeklyDate = WeeklyDate(exc: _exercise!,list: list);
        _xData = weeklyDate.datesNames;
        if (weeklyDate.weightList != null) {
          _yData = weeklyDate.weightList!;
        }
        break;
      case '1M':
        MonthlyDates monthlyDates = MonthlyDates(exc: _exercise!,listData: list);
        _xData = monthlyDates.dates;
        _yData = monthlyDates.weightList;
        break;
      case '3M':
        MultipleMonthlyDates multipleMonthlyDates =
        MultipleMonthlyDates(exc: _exercise!, numMonth: 3,listData: list);
        _xData = multipleMonthlyDates.dates;
        _yData = multipleMonthlyDates.weightList;
        break;
      case '6M':
        MultipleMonthlyDates multipleMonthlyDates =
        MultipleMonthlyDates(exc: _exercise!, numMonth: 6,listData: list);
        _xData = multipleMonthlyDates.dates;
        _yData = multipleMonthlyDates.weightList;
        break;
      case '1Y':
        MultipleMonthlyDates multipleMonthlyDates =
        MultipleMonthlyDates(exc: _exercise!, numMonth: 12,listData: list);
        _xData = multipleMonthlyDates.dates;
        _yData = multipleMonthlyDates.weightList;
        break;
      default:
        print('Invalid period selected');
    }
    initializeMaxVals();
  }
}


