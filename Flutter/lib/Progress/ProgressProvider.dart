import 'dart:convert';

import 'package:IOFit/Plans/History.dart';
import 'package:IOFit/Plans/PlanList/plan_data.dart';
import 'package:IOFit/Plans/PlanProvider.dart';
import 'package:IOFit/Progress/UpcomingWorkoutListMember.dart';
import 'package:IOFit/models/historymodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/form_field_controller.dart';
import 'workoutProgramData.dart';
import 'Achievements.dart';

class ProgressProvider with ChangeNotifier {
  // Keys and Controllers
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Map<String, AnimationInfo> animationsMap = {};
  final FocusNode unfocusNode = FocusNode();

  // Private Variables
  String historyPress = 'All';
  bool _visible = false;
  int _isGeneral = 0;
  late String uid;
  String _clickPress = '1W';
  String? _dropDownValue;
  late List<WorkoutProgramData> _progressData = [];
  TabController? _tabBarController;
  FormFieldController<String>? _dropDownValueController;
  List<String>? _excList;
  late PlanProvider planProvider;
  late List<UpcomingWorkoutList> upcomingWorkoutsList = [];
  late List<UpcomingWorkoutList> filteredUpcomingWorkoutsList = [];

  late List<UpcomingWorkoutList> finishedWorkoutlist = [];
  late GeneralAchievements achievements;

  ProgressProvider() {
    _progressData = (WorkoutProgramList.listWorkout);
    _excList = getList();
  }

  void reset() {
    // Basic UI & filter fields
    historyPress = 'All';
    _visible = false;
    _isGeneral = 0;
    uid = '';
    _clickPress = '1W';
    _dropDownValue = null;

    // Clear data
    _progressData = [];
    _excList = [];
    upcomingWorkoutsList = [];
    filteredUpcomingWorkoutsList = [];
    finishedWorkoutlist = [];



    notifyListeners();
  }


  void initializeFinishWorkoutList() async {
    finishedWorkoutlist = await loadWorkoutList("${uid}finishList");
  }

  void updateUser(List<WorkoutProgramData> list,
      GeneralAchievements achievements, List<PlanTile> plans, userID) async {
    this._progressData = list;
    _excList = getList();
    print(_excList);
    this.achievements = achievements;
    upcomingWorkoutsList = [];
    initializeUpcomingWorkouts(plans);
    upcomingWorkoutsList = getWorkoutsByDays(
        upcomingWorkoutsList, WorkoutProgramList.getDayName(DateTime.now()));
    filteredUpcomingWorkoutsList = copyDataOfUpcomingList(upcomingWorkoutsList);
    uid = userID;
    historyPress = 'All';
    initializeFinishWorkoutList();
    _clickPress = '1W';

    await updateFinishList;
    initializeFilterList();
    notifyListeners();
  }

  List <UpcomingWorkoutList> copyDataOfUpcomingList(List <UpcomingWorkoutList> lst){
    if (lst == null) return [];
    List <UpcomingWorkoutList> copy = [];
    lst.forEach((element) {
      List<String> strList = [];
      element.workoutNameList.forEach((exc) {
        strList.add(exc);
      });
      UpcomingWorkoutList member = UpcomingWorkoutList(day: element.day, workoutNameList: strList);
      copy.add(member);
    });

    return copy;

  }


  List<String> getList() {
    return _progressData.map((item) => item.name).toList();
  }

  // Getters
  bool get visible => _visible;

  int get isGeneral => _isGeneral;

  String get clickPress => _clickPress;

  String? get dropDownValue => _dropDownValue;

  TabController? get tabBarController => _tabBarController;

  FormFieldController<String>? get dropDownValueController =>
      _dropDownValueController;

  List<String>? get excList => _excList;

  List<WorkoutProgramData> get progressData => _progressData;

  void handleAddNewPlan(PlanTile plan) {
    addToUpcomingWorkoutsAllDays(upcomingWorkoutsList, plan);
    addToUpcomingWorkoutsAllDays(filteredUpcomingWorkoutsList, plan);
  }

  void initializeFilterList() {
    for (var finishedElement in finishedWorkoutlist) {
      // Find the matching day in the filteredUpcomingWorkoutsList
      final workoutForToday = filteredUpcomingWorkoutsList.firstWhere(
        (member) => finishedElement.day == member.day,
        orElse: () => UpcomingWorkoutList(
          day: finishedElement.day,
          workoutNameList: [],
        ),
      );

      // Remove finished workout names from the matching day
      finishedElement.workoutNameList.forEach((name) {
        workoutForToday.workoutNameList.removeWhere((member) => member == name);
      });

      // Update the filteredUpcomingWorkoutsList if necessary
      if (workoutForToday.workoutNameList.isEmpty) {
        filteredUpcomingWorkoutsList
            .removeWhere((member) => member.day == finishedElement.day);
      }
    }
  }

  void handleFinishWorkout(PlanTile plan) async {
    // Get the current day name
    final currentDay = WorkoutProgramList.getDayName(DateTime.now());

    // Find the element that matches the current day
    final workoutForToday = filteredUpcomingWorkoutsList.firstWhere(
      (element) => element.day == currentDay,
      orElse: () => UpcomingWorkoutList(
          day: 'defaultDay',
          workoutNameList: []), // Return null if no matching element is found
    );
    // Check if the workout exists for today
    if (workoutForToday.day != "defaultDay") {
      // Check if the plan name exists in the workout list
      if (workoutForToday.workoutNameList.contains(plan.title)) {
        // Remove the workout from the list
        workoutForToday.workoutNameList.remove(plan.title);
        addToUpcomingWorkouts(finishedWorkoutlist, plan,
            WorkoutProgramList.getDayName(DateTime.now()));
        print('Removed ${plan.title} from workouts on $currentDay.');
      } else {
        print('${plan.title} does not exist on $currentDay.');
      }
    } else {
      print('No workouts found for $currentDay.');
    }
    updateFinishList();
    notifyListeners();
  }

  void addToUpcomingWorkoutsAllDays(
      List<UpcomingWorkoutList> lst, PlanTile plan) {
    plan.days.forEach((element) {
      addToUpcomingWorkouts(lst, plan, element);
    });
    notifyListeners();
  }

  void addToUpcomingWorkouts(
      List<UpcomingWorkoutList> lst, PlanTile plan, String currentDay) {
    final matchingElement = lst.firstWhere(
      (element) => element.day == currentDay,
      orElse: () => UpcomingWorkoutList(
          day: 'defaultDay',
          workoutNameList: []), // Returns null if no match is found
    );
    if (matchingElement.day == 'defaultDay') {
      UpcomingWorkoutList newList =
          UpcomingWorkoutList(day: currentDay, workoutNameList: []);
      newList.workoutNameList.add(plan.title);
      lst.add(newList);
    } else {
      matchingElement.workoutNameList.add(plan.title);
    }
  }

  void initializeUpcomingWorkouts(List<PlanTile> planList) {
    planList.forEach((element) {
      List<String> days = element.days;
      days.forEach((day) {
        final matchingElement = upcomingWorkoutsList.firstWhere(
          (element) => element.day == day,
          orElse: () => UpcomingWorkoutList(
              day: 'defaultDay',
              workoutNameList: []), // Returns null if no match is found
        );
        if (matchingElement.day == 'defaultDay') {
          UpcomingWorkoutList newList =
              UpcomingWorkoutList(day: day, workoutNameList: []);
          newList.workoutNameList.add(element.title);
          upcomingWorkoutsList.add(newList);
        } else {
          matchingElement.workoutNameList.add(element.title);
        }
      });
    });
  }

  List<UpcomingWorkoutList> getWorkoutsByDays(
      List<UpcomingWorkoutList> upcomingWorkoutsList, String startDay) {
    // Define the standard order of days
    const allDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Find the index of the starting day in the standard order
    final startIndex = allDays.indexOf(startDay);

    // Create a new list to hold the filtered workouts
    final List<UpcomingWorkoutList> filteredWorkoutsList = [];

    // If the startDay is valid (exists in allDays), proceed
    if (startIndex != -1) {
      // Create a map to group workouts by day
      final Map<String, List<String>> workoutsMap = {};

      // Populate the map with workouts
      for (var workout in upcomingWorkoutsList) {
        workoutsMap
            .putIfAbsent(workout.day, () => [])
            .addAll(workout.workoutNameList);
      }

      // Create a circular order of days starting from startDay
      final dayOrder = [
        ...allDays.sublist(startIndex),
        // Days from startDay to the end
        ...allDays.sublist(0, startIndex),
        // Days from the beginning to startDay
      ];

      // Build the filtered list based on the new day order
      for (var day in dayOrder) {
        if (workoutsMap[day]?.isNotEmpty ?? false) {
          // Check if there's any workout
          filteredWorkoutsList.add(UpcomingWorkoutList(
            day: day,
            workoutNameList: workoutsMap[day]!,
          ));
        }
      }
    } else {
      // If startDay is not valid, print an error message
      print('Invalid start day provided. Please use a valid day name.');
    }

    return filteredWorkoutsList; // Return the filtered list
  }

  List<String> changeStrUpcomingLst() {
    List<String> lst = [];
    filteredUpcomingWorkoutsList.forEach((day) {
      day.workoutNameList.forEach((name) {
        lst.add("${day.day}: $name");
      });
    });
    return lst;
  }

  // Setters
  set visible(bool value) {
    if (_visible != value) {
      _visible = value;
    }
  }

  set isGeneral(int value) {
    if (_isGeneral != value) {
      _isGeneral = value;
    }
  }

  set clickPress(String value) {
    if (_clickPress != value) {
      _clickPress = value;
    }
  }

  set dropDownValue(String? value) {
    if (_dropDownValue != value) {
      _dropDownValue = value;
    }
  }

  set dropDownValueController(FormFieldController<String>? controller) {
    _dropDownValueController = controller;
  }

  set tabBarController(TabController? controller) {
    _tabBarController = controller;
  }

  // Methods to initialize controllers that require TickerProvider
  void initializeTabBarController(TickerProvider vsync, int length) {
    _tabBarController = TabController(length: length, vsync: vsync);
  }

  void initializeExcList() {
    _excList = WorkoutProgramList.getList();
  }

  void dropDownClick(String str) {
    visible = true;
    dropDownValue = str;
    notifyListeners();
  }

  void dateClick(String str) {
    clickPress = str;
    notifyListeners();
  }


  void dateClickHistory (String str){
    historyPress = str;
    notifyListeners();
}

  void updateAchievements(HistoryModel exc) {
    achievements.handleFinish(exc);
    notifyListeners();
  }

  void updateFinishList() async {
    // Use removeWhere to safely remove items from the list
    finishedWorkoutlist.removeWhere((element) =>
        element.day != WorkoutProgramList.getDayName(DateTime.now()));

    // Save the updated list to SharedPreferences
    await saveWorkoutList('${uid}finishList', finishedWorkoutlist);
  }

  // Save a list of UpcomingWorkoutList to SharedPreferences
  static Future<void> saveWorkoutList(
      String key, List<UpcomingWorkoutList> workouts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList =
        workouts.map((workout) => jsonEncode(workout.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  // Load a list of UpcomingWorkoutList from SharedPreferences
  static Future<List<UpcomingWorkoutList>> loadWorkoutList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(key);

    if (jsonList == null) {
      return [];
    }

    return jsonList
        .map((jsonString) =>
            UpcomingWorkoutList.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  int countSpaces(double val, String str) {
    return val.abs().toString().length + str.length;
  }

  // Dispose method to clean up controllers and focus nodes
  @override
  void dispose() {
    _tabBarController?.dispose();
    unfocusNode.dispose();
    super.dispose();
  }
}
