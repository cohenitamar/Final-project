import 'package:IOFit/Plans/PlanProvider.dart';
import 'package:IOFit/Progress/HistoryPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Plans/History.dart';




class CalendarProvider extends ChangeNotifier {

  ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  List<DateTime> historyList=[];
  CalendarProvider(HistoryPageProvider provider){
  }



  void addDate(DateTime date){
    historyList.add(date);
    notifyListeners();
  }
  ValueNotifier<DateTime> get focusedDay => _focusedDay;
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  void handleDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _focusedDay.value = focusedDay;
    _selectedDay = selectedDay;
    notifyListeners();
  }

  void changeFocusVal(DateTime focusedDay) {
    _focusedDay.value = focusedDay;
    notifyListeners();
  }

  DateTime get selectedDay => _selectedDay;

  CalendarFormat get calendarFormat => _calendarFormat;



  List<DateTime> getDatesFromHistoryList(List<ExecutedPlan> list){
    List<DateTime> dateList = [];
    list.forEach((element) {
      DateTime parsedDate = DateFormat('dd.MM.yyyy').parse(element.executionDate);
      if(!(dateList.contains(parsedDate))){
        dateList.add(parsedDate);
      }
    });
    return dateList;
  }

  void initList(List<ExecutedPlan> list){
    this.historyList = getDatesFromHistoryList(list);
    notifyListeners();


  }
  @override
  void dispose(){
    _focusedDay.dispose();
    super.dispose();
  }

}