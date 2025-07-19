import '/flutter_flow/flutter_flow_util.dart';
import 'ProgressProvider.dart';
import 'PersonGeneralData.dart';

class WorkoutProgramData {
  String name;
  List<DataByWeek> dataByDateWeek;
   late String id;
   late String userID;

  WorkoutProgramData({required this.name, required this.dataByDateWeek,
  id,userID});
}

class WorkoutProgramList {
  static List<WorkoutProgramData> listWorkout = [
    WorkoutProgramData(name: 'Atlas Stones', dataByDateWeek: [
      DataByWeek(
        weekNum: 19,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 5, date: DateTime(2024, 5, 7), reps: 5, sets: 3),
          DataByDate(weight: 6, date: DateTime(2024, 5, 9), reps: 6, sets: 4),
          DataByDate(weight: 7, date: DateTime(2024, 5, 11), reps: 7, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 20,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 6, date: DateTime(2024, 5, 14), reps: 5, sets: 3),
          DataByDate(weight: 7, date: DateTime(2024, 5, 16), reps: 6, sets: 4),
          DataByDate(weight: 8, date: DateTime(2024, 5, 18), reps: 7, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 21,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 7, date: DateTime(2024, 5, 21), reps: 6, sets: 3),
          DataByDate(weight: 8, date: DateTime(2024, 5, 23), reps: 7, sets: 4),
          DataByDate(weight: 9, date: DateTime(2024, 5, 25), reps: 8, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 22,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 8, date: DateTime(2024, 5, 28), reps: 6, sets: 3),
          DataByDate(weight: 9, date: DateTime(2024, 5, 30), reps: 7, sets: 4),
          DataByDate(weight: 10, date: DateTime(2024, 6, 1), reps: 8, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 23,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 9, date: DateTime(2024, 6, 4), reps: 6, sets: 3),
          DataByDate(weight: 10, date: DateTime(2024, 6, 6), reps: 7, sets: 4),
          DataByDate(weight: 11, date: DateTime(2024, 6, 8), reps: 8, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 24,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 10, date: DateTime(2024, 6, 11), reps: 7, sets: 3),
          DataByDate(weight: 11, date: DateTime(2024, 6, 13), reps: 8, sets: 4),
          DataByDate(weight: 12, date: DateTime(2024, 6, 15), reps: 9, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 25,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 11, date: DateTime(2024, 6, 18), reps: 7, sets: 3),
          DataByDate(weight: 12, date: DateTime(2024, 6, 20), reps: 8, sets: 4),
          DataByDate(weight: 13, date: DateTime(2024, 6, 22), reps: 9, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 26,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 12, date: DateTime(2024, 6, 25), reps: 7, sets: 3),
          DataByDate(weight: 13, date: DateTime(2024, 6, 27), reps: 8, sets: 4),
          DataByDate(weight: 14, date: DateTime(2024, 6, 29), reps: 9, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 27,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 13, date: DateTime(2024, 7, 2), reps: 7, sets: 3),
          DataByDate(weight: 14, date: DateTime(2024, 7, 4), reps: 8, sets: 4),
          DataByDate(weight: 15, date: DateTime(2024, 7, 6), reps: 9, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 28,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 14, date: DateTime(2024, 7, 9), reps: 7, sets: 3),
          DataByDate(weight: 15, date: DateTime(2024, 7, 11), reps: 8, sets: 4),
          DataByDate(weight: 16, date: DateTime(2024, 7, 13), reps: 9, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 29,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 14, date: DateTime(2024, 7, 16), reps: 8, sets: 3),
          DataByDate(weight: 15, date: DateTime(2024, 7, 18), reps: 9, sets: 4),
          DataByDate(
              weight: 16, date: DateTime(2024, 7, 20), reps: 10, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 30,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 15, date: DateTime(2024, 7, 23), reps: 8, sets: 3),
          DataByDate(weight: 16, date: DateTime(2024, 7, 25), reps: 9, sets: 4),
          DataByDate(
              weight: 17, date: DateTime(2024, 7, 27), reps: 10, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 31,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 16, date: DateTime(2024, 7, 30), reps: 8, sets: 3),
          DataByDate(weight: 17, date: DateTime(2024, 8, 1), reps: 9, sets: 4),
          DataByDate(weight: 18, date: DateTime(2024, 8, 3), reps: 10, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 32,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 17, date: DateTime(2024, 8, 6), reps: 8, sets: 3),
          DataByDate(weight: 18, date: DateTime(2024, 8, 8), reps: 9, sets: 4),
          DataByDate(
              weight: 19, date: DateTime(2024, 8, 10), reps: 10, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 33,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 18, date: DateTime(2024, 8, 13), reps: 9, sets: 3),
          DataByDate(
              weight: 19, date: DateTime(2024, 8, 15), reps: 10, sets: 4),
          DataByDate(
              weight: 20, date: DateTime(2024, 8, 17), reps: 12, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 34,
        year: 2024,
        dataByDate: [
          DataByDate(
              weight: 19, date: DateTime(2024, 8, 20), reps: 11, sets: 3),
          DataByDate(
              weight: 18, date: DateTime(2024, 8, 22), reps: 10, sets: 4),
          DataByDate(
              weight: 20, date: DateTime(2024, 8, 24), reps: 12, sets: 4),
        ],
      ),
      DataByWeek(
        weekNum: 35,
        year: 2024,
        dataByDate: [
          DataByDate(
              weight: 20, date: DateTime(2024, 8, 27), reps: 10, sets: 3),
          DataByDate(
              weight: 21, date: DateTime(2024, 8, 29), reps: 12, sets: 4),
          DataByDate(weight: 22, date: DateTime(2024, 8, 31), reps: 8, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 35,
        year: 2024,
        dataByDate: [
          DataByDate(
              weight: 20, date: DateTime(2024, 8, 27), reps: 10, sets: 3),
          DataByDate(
              weight: 21, date: DateTime(2024, 8, 29), reps: 12, sets: 4),
          DataByDate(weight: 22, date: DateTime(2024, 8, 31), reps: 8, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 36,
        year: 2024,
        dataByDate: [
          DataByDate(weight: 22, date: DateTime(2024, 9, 3), reps: 10, sets: 3),
          DataByDate(weight: 23, date: DateTime(2024, 9, 5), reps: 11, sets: 4),
          DataByDate(weight: 24, date: DateTime(2024, 9, 7), reps: 9, sets: 3),
        ],
      ),
      DataByWeek(
        weekNum: 37,
        year: 2024,
        dataByDate: [
          DataByDate(
              weight: 23, date: DateTime(2024, 9, 10), reps: 12, sets: 3),
          DataByDate(
              weight: 24, date: DateTime(2024, 9, 12), reps: 10, sets: 4),
          DataByDate(weight: 25, date: DateTime(2024, 9, 14), reps: 8, sets: 5),
        ],
      ),
      DataByWeek(
        weekNum: 38,
        year: 2024,
        dataByDate: [
          DataByDate(
              weight: 25, date: DateTime(2024, 9, 17), reps: 11, sets: 3),
          DataByDate(
              weight: 26, date: DateTime(2024, 9, 19), reps: 10, sets: 4),
          DataByDate(weight: 27, date: DateTime(2024, 9, 21), reps: 9, sets: 5),
        ],
      ),
      DataByWeek(weekNum: 39, year: 2024, dataByDate: [
        DataByDate(weight: 21, date: DateTime(2024, 9, 24), reps: 10, sets: 3),
        DataByDate(weight: 21, date: DateTime(2024, 9, 26), reps: 10, sets: 3),
        DataByDate(weight: 21, date: DateTime(2024, 9, 28), reps: 10, sets: 3)
      ]),
      DataByWeek(weekNum: 40, year: 2024, dataByDate: [
        DataByDate(weight: 22, date: DateTime(2024, 10, 2), reps: 10, sets: 3)
      ]),
    ]
// Provide appropriate DataByDate list
        ),
  ];

  // returns a list with all the exercises names
  static List<String> getList() {
    List<String> newList = [];
    listWorkout.forEach((item) {
      newList.add(item.name);
    });
    return newList;
  }

  // returns the weeknum of a specific date

  static int getWeekNumber(DateTime date) {
    // Get the first day of the year
    DateTime firstDayOfYear = DateTime(date.year, 1, 1);

    // Adjust so that the first Monday is considered the start of the first week
    DateTime firstMonday =
        firstDayOfYear.subtract(Duration(days: firstDayOfYear.weekday - 1));

    // If the date is before the first Monday, it's in the last week of the previous year
    if (date.isBefore(firstMonday)) {
      return getWeekNumber(DateTime(date.year - 1, 12, 31));
    }

    // Calculate the week number
    int weekNumber = ((date.difference(firstMonday).inDays + 1) / 7).ceil();

    return weekNumber;
  }

  // returns WorkoutProgramData when name == exc
  static WorkoutProgramData? getExercise(String exc,List <WorkoutProgramData> list) {
    try {
      return list.firstWhere((element) => element.name == exc);
    } catch (e) {
      // If no match is found, return null or handle the error accordingly
      return null;
    }
  }

  static DataByWeek? getDataByWeek(
      int weekNum, int year, List<DataByWeek> list) {
    try {
      return list.lastWhere(
          (element) => (element.weekNum == weekNum) && (element.year == year));
    } catch (e) {
      // If no match is found, return null or handle the error accordingly
      return null;
    }
  }

  static bool areDatesEqual(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static DataByDate? getDataByDay(DateTime date, List<DataByDate> list) {
    try {
      return list.lastWhere((element) => areDatesEqual(element.date, date));
    } catch (e) {
      // If no match is found, return null or handle the error accordingly
      return null;
    }
  }

  static int getWeightOfData(DateTime date, List<DataByDate> list) {
    DataByDate? dataByDate = getDataByDay(date, list);
    if (dataByDate == null) {
      return 0;
    } else {
      return dataByDate.weight;
    }
  }

  static void addToList(
      int day, List<int> weightList, DataByWeek? week, DateTime date) {
    if ((week != null) && (week.dataByDate != null)) {
      for (int i = 0; i < day; i++) {
        weightList
            .add(getWeightOfData(date.add(Duration(days: i)), week.dataByDate));
      }
    } else {
      for (int i = 0; i < day; i++) {
        weightList.add(0);
      }
    }
  }

  static void addToListOnSunday(
      int day, List<int> weightList, DataByWeek? prevWeek) {
    DateTime prevRemain = DateTime.now().subtract(Duration(days: (6)));
    addToList(7 - day, weightList, prevWeek, prevRemain);
    addToList(day,weightList,prevWeek,prevRemain);
  }

  static void addToListNotSunday(int day, List<int> weightList,
      DataByWeek? prevWeek, DataByWeek? curWeek) {
    DateTime prevRemain = DateTime.now().subtract(Duration(days: (6)));
    DateTime startWeek = DateTime.now().subtract(Duration(days: (day - 1)));
    addToList(7 - day, weightList, prevWeek, prevRemain);
    addToList(day, weightList, curWeek, startWeek);
  }

  static List<int>? DataOfLastWeek(String exc,List<WorkoutProgramData> list) {
    try {
      List<int> weightList = [];
      int weekNum = getWeekNumber(DateTime.now());
      int day = (DateTime.now().weekday);
      WorkoutProgramData? exercise = getExercise(exc,list);
      if (exercise == null) {
        return null;
      }
      int year = (DateTime.now().year) - 1;
      int prevWeekNum = getWeekNumber(DateTime(year - 1, 12, 31));
      if (weekNum != 1) {
        prevWeekNum = weekNum - 1;
        year++;
      }
      DataByWeek? curWeek =
          getDataByWeek(weekNum, DateTime.now().year, exercise.dataByDateWeek);
      DataByWeek? prevWeek =
          getDataByWeek(prevWeekNum, year, exercise.dataByDateWeek);
      if (day != 7) {
        addToListNotSunday(day, weightList, prevWeek, curWeek);
      } else {
        addToListOnSunday(day, weightList, curWeek);
      }
      return weightList;
    } catch (e) {
      // If no match is found, return null or handle the error accordingly
      return null;
    }
  }

  static DateTime getLastMonthDay(DateTime inputDate) {
    DateTime today =
        inputDate; // Use the input date instead of the current date
    int lastMonth = today.month - 1; // Determine the last month
    int year = today.year; // Get the current year
    // Adjust month and year if it's January
    if (lastMonth == 0) {
      lastMonth = 12; // December
      year--; // Go back a year
    }
    // Use the same day of the month as today, or adjust if it doesn't exist
    int dayOfMonth = today.day;
    DateTime lastMonthDate = DateTime(
        year, lastMonth, dayOfMonth); // Initial attempt for the last month
    // Check if the last month has the same day
    if (dayOfMonth > DateTime(year, lastMonth + 1, 0).day) {
      lastMonthDate =
          DateTime(year, lastMonth, DateTime(year, lastMonth + 1, 0).day);
    }
    return lastMonthDate; // Return the calculated date
  }

  static List<DataByWeek>? getListByMonth(String exc, DateTime date,List<WorkoutProgramData> listData) {
    WorkoutProgramData? exercise = getExercise(exc,listData);
    int currWeek = getWeekNumber(date);
    int theLastWeek = getWeekNumber(DateTime(date.year - 1, 12, 31));
    int remain = 100;
    int numWeekInMonth = 5;
    int firstWeekOfMonth = currWeek - numWeekInMonth;
    if (currWeek <= numWeekInMonth) {
      firstWeekOfMonth = 1;
      remain = theLastWeek - (numWeekInMonth - currWeek);
    }
    if (exercise == null) {
      return null;
    }
    List<DataByWeek> list = [];
    if (remain == 100) {
      exercise.dataByDateWeek.forEach((element) {
        if (element.weekNum <= currWeek &&
            element.weekNum >= firstWeekOfMonth &&
            element.year == date.year) {
          list.add(element);
        }
      });
    } else {
      exercise.dataByDateWeek.forEach((element) {
        if ((element.weekNum <= currWeek &&
                element.weekNum >= firstWeekOfMonth &&
                element.year == date.year) ||
            (element.weekNum <= theLastWeek &&
                element.weekNum >= remain &&
                element.year == date.year - 1)) {
          list.add(element);
        }
      });
    }
    return list;
  }

  static List<DataByDate>? getListOfDaysBYMonth(
      List<DataByWeek> list, DateTime date) {
    List<DataByDate> resultList = [];
    // Iterate through each DataByWeek object in the list
    DateTime lastMonth = getLastMonthDay(date);
    list.forEach((element) {
      List<DataByDate>? dataByDateList = element.dataByDate;
      // If the list is not null, filter and add items to resultList
      if (dataByDateList != null) {
        for (var data in dataByDateList) {
          if ((data.date.compareTo(lastMonth) >= 0) &&
              DateTime.now().compareTo(data.date) >= 0) {
            resultList.add(data);
          }
        }
      }
    });
    return resultList; // Return the combined resultList
  }

  static List<String> convertDates2Strings(List<DataByDate> list) {
    List<String> strList = [];
    if (list != null) {
      list.forEach((element) {
        strList.add(DateFormat('dd/MM').format(element.date));
      });
    }
    return strList;
  }

  static List<int> getDataFromList(List<DataByDate> list) {
    List<int> strList = [];
    if (list != null) {
      list.forEach((element) {
        strList.add(element.weight);
      });
    }
    return strList;
  }
   static List<DataByDate> filterList(List<DataByDate> dataList) {
    // Sort the list by date using your existing compare method.
    dataList.sort((a, b) => a.compare(b));

    // Use a Map to store entries by day (ignores time).
    Map<String, DataByDate> filteredMap = {};

    for (var entry in dataList) {
      // Format the date to a string representing only the day (ignoring time).
      String dayString = "${entry.date.year}-${entry.date.month}-${entry.date.day}";

      // If the day is not in the map, or we want to update it with a newer entry, update the map.
      filteredMap[dayString] = entry;
    }

    // Return the filtered list of entries.
    return filteredMap.values.toList();
  }


  static List<DataByDate>? getListOfDaysForMultipleMonths(
      String exc, numMonths,List<WorkoutProgramData> list) {
    List<DataByDate> resultList = [];
    DateTime now = DateTime.now();
    int month = now.month;
    int year = now.year;
    for (int i = 0; i < numMonths; i++) {
      if (month == 0) {
        month = 12;
        year--;
      }
      DateTime date = DateTime(year, month, now.day);

      List<DataByWeek>? weekList = getListByMonth(exc, date,list);
      List<DataByDate>? monthList = getListOfDaysBYMonth(weekList!, date);
      monthList = filterList(monthList!);

      if (monthList != null && monthList.isNotEmpty) {
        resultList.addAll(monthList);
      }
      month--;
    }
    return resultList;
  }

  static List<DataByDate>? getBalancedDataForMultipleMonths(List<WorkoutProgramData> list,
      String exc, int numMonths, int limit) {
    WorkoutProgramData? data = WorkoutProgramList.getExercise(exc,list);
    if (data == null || data.dataByDateWeek.isEmpty) {
      return null;
    }

    List<DataByDate>? dataList =
        WorkoutProgramList.getListOfDaysForMultipleMonths(exc, numMonths,list);
    if (dataList == null) {
      return null;
    }
    // Sort the list by date using the custom compare method
    dataList.sort((a, b) => a.compare(b)); // Use your custom compare method
    // Get the length of the list
    int totalData = dataList.length;
    // If the list contains fewer than or equal to the limit, return the original list
    if (totalData <= limit) {
      return List.from(
          dataList); // Return a new list to avoid modification of the original
    }
    // Calculate the interval between selected data points
    double step = totalData / limit;
    // Create a new list to store the balanced data
    List<DataByDate> balancedData = [];
    // Select data using the calculated step
    for (int i = 0; i < limit; i++) {
      int index = (i * step).floor();
      balancedData.add(dataList[index]);
    }
    return balancedData;
  }


  static String getDayName(DateTime date) {
    // Define the standard order of days
    const allDays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    // Get the day of the week from the DateTime object (1 = Monday, 7 = Sunday)
    int dayOfWeek = date.weekday;

    // Return the corresponding day name
    return allDays[dayOfWeek - 1]; // Subtract 1 because index is 0-based
  }

}

class WeeklyDate {
  List<String> datesNames = [];
  List<int>? weightList;

  WeeklyDate({required String exc,required List<WorkoutProgramData> list}) {
    weightList = WorkoutProgramList.DataOfLastWeek(exc,list);
    print(exc);
    print(weightList);
    List<String> dates = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    int day = DateTime.now().weekday;
    for (int i = 0; i < 7; i++) {
      datesNames.add(dates.elementAt((day + 1 + i) % 7));
    }
  }
}

class MonthlyDates {
  List<String> dates = [];
  List<int> weightList = [];

  MonthlyDates({required String exc,required List<WorkoutProgramData> listData}) {
    int numMonth = 1;
    int limit = 8;
    List<DataByDate>? list =
        WorkoutProgramList.getBalancedDataForMultipleMonths(
            listData,exc, numMonth, limit);
    if (list != null) {
      weightList = WorkoutProgramList.getDataFromList(list);
      dates = WorkoutProgramList.convertDates2Strings(list);
    }
  }
}

class MultipleMonthlyDates {
  List<String> dates = [];
  List<int> weightList = [];

  MultipleMonthlyDates({required String exc, required int numMonth, required List<WorkoutProgramData> listData}) {
    int limit = 8;
    List<DataByDate>? list =
        WorkoutProgramList.getBalancedDataForMultipleMonths(
            listData,exc, numMonth, limit);
    if (list != null) {
      weightList = WorkoutProgramList.getDataFromList(list);
      dates = WorkoutProgramList.convertDates2Strings(list);
    }
  }
}




