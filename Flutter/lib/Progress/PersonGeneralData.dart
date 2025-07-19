import 'dart:collection';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DataByDate{
  int weight;
  int reps;
  int sets;
  DateTime date;

  DataByDate({
    required this.weight,
    required this.reps,
    required this.sets,
    required this.date,
  });
  int compare(DataByDate b) {
    return this.date.compareTo(b.date);
  }

}
List<DataByWeek> data =
   [DataByWeek(weekNum: 20,year:2024, dataByDate: [DataByDate(weight: 20, date: DateTime(2024,5,17),reps:10,sets: 3)]),
DataByWeek(weekNum: 21,year:2024, dataByDate: [DataByDate(weight: 21, date: DateTime(2024,5,24),reps:10,sets: 3)]),
DataByWeek(weekNum: 22, year:2024,dataByDate: [DataByDate(weight: 22, date: DateTime(2024,5,31),reps:10,sets: 3)]),
DataByWeek(weekNum: 23, year:2024,dataByDate: [DataByDate(weight: 25, date: DateTime(2024,7,7),reps:10,sets: 3)])];

class DataByWeek {
  int weekNum;
  int year;
  List <DataByDate> dataByDate;

  DataByWeek({
    required this.weekNum,
    required this.dataByDate,
    required this.year,
  });
}
class GeneralData {
  String dataName;
  List <DataByWeek> dataByDateWeek;
  String measurementUnites;

  GeneralData({
    required this.dataName,
    required this.dataByDateWeek,
    required this.measurementUnites,
  });
}
class GeneralDataList {

  static List<GeneralData> list = [
    GeneralData(dataName: "Weight", dataByDateWeek: data, measurementUnites: "kg"),
    GeneralData(dataName: "Body Fat", dataByDateWeek: data, measurementUnites: "%"),
    GeneralData(dataName: "Total Weight Lifted", dataByDateWeek: data, measurementUnites: "kg"),
    GeneralData(dataName: "Workouts This Week", dataByDateWeek: data, measurementUnites: "/7"),
    GeneralData(dataName: "Total reps", dataByDateWeek: data, measurementUnites: "reps"),
    GeneralData(dataName: "Average Workout Time", dataByDateWeek: data, measurementUnites: "min")
  ];
  static DataByDate getLastData(String name){
    GeneralData generalData;
    DataByWeek lastWeek;
    DataByDate date = DataByDate(weight: 10, date: DateTime(2024,5,24),reps:10,sets: 3);

    for (var item in list){
      if (item.dataName == name){
        generalData=item;
        lastWeek  = generalData.dataByDateWeek.last;
        date = lastWeek.dataByDate.last;
      }
    }
   return date;
  }

  static GeneralData findByname(String str) {
    for (var item in list) {
      if (item.dataName == str) {
        return item;
      }
    }
    return GeneralData(dataName: "dataName", dataByDateWeek: [], measurementUnites: "measurementUnites");
    // Return null if the item is not found
  }
  static int getWeekOfYear(DateTime date) {
    // Get the Thursday of the same week as the given date
    DateTime thursday = date.subtract(Duration(days: date.weekday - DateTime.thursday));
    // Calculate the difference in days between the given date and the Thursday
    int difference = date.difference(thursday).inDays;
    // Calculate the week number
    int weekNumber = (date.difference(DateTime(date.year, 1, 1)).inDays + difference + 3) ~/ 7;
    return weekNumber;
  }

  static List<DataByDate> classifyByWeeks(str) {
    List<DataByDate> list = [];
    GeneralData exercise = findByname(str);
    DateTime now = DateTime.now();
    int week = getWeekOfYear(now);
    DataByWeek curWeek;
    int index = -1;
    for (var item in exercise.dataByDateWeek) {
      if (item.weekNum == week) {
        curWeek=item;
        index = exercise.dataByDateWeek.indexOf(curWeek);

      }
    }
    int length = exercise.dataByDateWeek.length;
    if (length <=5){
      for (var item in exercise.dataByDateWeek){
        list.add(item.dataByDate.last);
      }
    }
    else{
      for (int i=index-4;i<index+1;i++){
        list.add(exercise.dataByDateWeek.elementAt(index).dataByDate.last);
      }
    }
    return list;
  }
  static List<DateTime> getDates(str){
    List<DateTime> list = [];
    List<DataByDate> l = classifyByWeeks(str);
    for(var item in l ){
      list.add(item.date);
    }
    return list;

  }
  static List<int> getData(str){
    List<int> list = [];
    List<DataByDate> l = classifyByWeeks(str);
    for(var item in l ){
      list.add(item.weight);
    }
    return list;
  }
  int getWeekNumber(DateTime date) {
    // Get the first day of the year
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);
    // Calculate the difference in days from the first day of the year to the current date
    int dayOfYear = date.difference(firstDayOfYear).inDays + 1;
    // Find which day of the week the year started on (Monday = 1, ..., Sunday = 7)
    int weekDayOfFirstDay = firstDayOfYear.weekday;
    // Calculate the week number
    int weekNumber = ((dayOfYear + (weekDayOfFirstDay - 1)) / 7).ceil();
    return weekNumber;
  }
  String getDayName(DateTime date) {
    // Define a list with day names where Sunday is the first day.
    List<String> dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    // Adjust the weekday so that Sunday becomes 0 instead of 7
    return dayNames[date.weekday % 7];  // Using mod to wrap Sunday to index 0
  }





}

