import 'dart:math';

import 'package:IOFit/Progress/ProgressProvider.dart';
import 'package:IOFit/Progress/workoutProgramData.dart';
import 'package:IOFit/api/stats_api_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Adapters/AchievmentAdapter.dart';
import '../Homepage/CalendarProvider.dart';
import '../Login/LoginProvider.dart';
import '../Progress/HistoryPageProvider.dart';
import '../Progress/PersonGeneralData.dart';
import '../Social/SocialPlan.dart';
import '../Social/SocialProvider.dart';
import '../User/User.dart';
import '../api/plan_api_service.dart';
import '../models/historymodel.dart';
import '../models/planmodel.dart';
import '../models/poststatsmodel.dart';
import '../notifications_manager.dart';
import 'PlanBuild/build_plan_widget.dart';
import 'PlanList/plan_data.dart'; // Ensure this contains your PlanTile definition
import 'plan_exercise.dart'; // For PlanExercise
import '../../SearchExercise/exercise.dart'; // For Exercise class
import 'dart:convert';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:intl/intl.dart';

class PlanProvider with ChangeNotifier {
  // Initialize Dio and ApiService
  final Dio _dio = Dio();
  late final PlanApiService _apiService = PlanApiService(_dio);
  late final StatsApiService _statsApiService = StatsApiService(_dio);

  List<PlanTile> _plans = [];
  List<PlanTile> _suggestedPlans = [];

  // UI State Variables
  bool _showAddedExercisesOnly = false;
  String _searchQuery = '';
  List<Exercise> _exercises = [];
  Map<int, bool> _isEditingPlan = {};
  Map<int, bool> _isTimerRunning = {};
  Map<int, StopWatchTimer> _timers = {};
  Map<int, Set<String>> _expandedExercises = {};

  // Getters for UI state
  bool get showAddedExercisesOnly => _showAddedExercisesOnly;

  String get searchQuery => _searchQuery;

  List<Exercise> get exercises => _exercises;

  // Methods to update UI state
  void toggleShowAddedExercisesOnly() {
    _showAddedExercisesOnly = !_showAddedExercisesOnly;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  set suggestedPlans(List<PlanTile> value) {
    _suggestedPlans = value;
  }

  List<PlanTile> get plans => _plans;

  List<PlanTile> get suggestedPlans => _suggestedPlans;

  final _pushManager = PushNotificationManager();


  void reset() {
    // Clear or re-initialize all fields to default
    _plans = [];
    _suggestedPlans = [];
    _showAddedExercisesOnly = false;
    _searchQuery = '';
    _exercises = [];

    _isEditingPlan = {};
    _isTimerRunning = {};
    _timers.forEach((_, timer) => timer.dispose());
    _timers.clear();
    _expandedExercises = {};

    notifyListeners();
  }


  Future<void>  addNotifications()async {
    final Map<String, int> dayToNumberMap = {
      "Sunday": 7,
      "Monday": 1,
      "Tuesday": 2,
      "Wednesday": 3,
      "Thursday": 4,
      "Friday": 5,
      "Saturday": 6,
    };

    final days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    int count = 0;

    plans.forEach((element) {
      element.days.forEach((day) async {
        // Generate unique IDs for morning and evening notifications
        final int morningNotificationId =
            "${element.id}_${day}_morning".hashCode;
        final int eveningNotificationId =
            "${element.id}_${day}_evening".hashCode;

        // Add the 10:00 AM notification if it doesn't exist
        await _pushManager.scheduleWeeklyNotification(
          id: morningNotificationId,
          title: "Morning Reminder for you",
          body: "Don't forget your workout: " + element.title + " today",
          timeOfDay: TimeOfDay(
            hour: 10,
            minute: 0,
          ),
          weekday: dayToNumberMap[day]!,
        );
        await _pushManager.scheduleWeeklyNotification(
          id: eveningNotificationId,
          title: "Afternoon Reminder for you",
          body: "Don't forget your workout: " + element.title + " today",
          timeOfDay: TimeOfDay(
            hour: 17,
            minute: 0,
          ),
          weekday: dayToNumberMap[day]!,
        );
      });
    });
  }

  void removeNotifications(int index) async {
    final deletedID = _plans[index].id;
    final plan = _plans[index];
    plan.days.forEach((day) async {
      final int morningNotificationId = "${deletedID}_${day}_morning".hashCode;
      final int eveningNotificationId = "${deletedID}_${day}_evening".hashCode;
      await _pushManager.cancelNotification(morningNotificationId);
      await _pushManager.cancelNotification(eveningNotificationId);
    });
  }

  String generateRandomString() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()_+-=[]{}|;:\'",.<>?/`~';
    Random random = Random();

    return List.generate(30, (index) => chars[random.nextInt(chars.length)])
        .join('');
  }

  Future<String?> getUserToken() async {
    try {
      // Get the current user
      auth.User? user = auth.FirebaseAuth.instance.currentUser;

      // Ensure the user is not null
      if (user == null) {
        throw Exception("No user is logged in");
      }

      // Get the token
      String? token = await user.getIdToken();
      return "Bearer " + token!;
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  Future<void> addSharedPlan(PlanTile plan) async {
    PlanTile newPlan = (PlanTile(
      id: plan.id,
      index: _plans.length,
      raters: plan.raters,
      title: plan.title,
      subTitle: plan.subTitle,
      userID: plan.userID,
      url: plan.url,
      cDate: plan.cDate,
      exercises: plan.exercises,
      isEditMode: false,
      rating: plan.rating,
      // Add default value
      days: plan.days, // Add days
    ));
    _plans.add(newPlan);
    notifyListeners();
  }

  Future<void> addPlan(String title, String subtitle, String url,
      List<String> days, ProgressProvider progress) async {
    PlanTile plan = (PlanTile(
      id: generateRandomString(),
      index: _plans.length,
      raters: {},
      title: title,
      subTitle: subtitle,
      userID: "",
      url: "Not in use",
      cDate: DateFormat('dd.MM.yyyy').format(DateTime.now()),
      exercises: [],
      isEditMode: false,
      rating: 0,
      // Add default value
      days: days, // Add days
    ));
    _plans.add(plan);
    decidePicture(_plans[_plans.length - 1]);

    notifyListeners();

    String? token = await getUserToken();
    late PlanModel res;
    if (token != null) {
      res = await _apiService.addPlan(
          token,
          PlanModel(
              id: "",
              userID: "",
              title: title,
              subTitle: subtitle,
              img: url,
              creationDate: DateFormat('dd.MM.yyyy').format(DateTime.now()),
              days: days,
              rating: 0,
              exercises: [],
              isShared: false,
              raters: {}));
      if (res.id != null) {
        plans[plans.length - 1].id = res.id!;
        progress.handleAddNewPlan(plan);
      } else {
        _plans.removeLast();
        notifyListeners();
      }
    }
  }

  Map<String, List<String>> muscleGroups = {
    'Upper Body': ['Biceps', 'Chest', 'Shoulders', 'Traps', 'Triceps'],
    'Core': ['Abdominals', 'Lower Back', 'Middle Back'],
    'Lower Body': ['Quadriceps', 'Hamstrings', 'Calves', 'Glutes'],
    'Back': ['Lats', 'Middle Back', 'Lower Back'],
  };

  void decidePicture(PlanTile plan) {
    int upperBody = 0, core = 0, lowerBody = 0, back = 0;
    for (PlanExercise e in plan.exercises) {
      String? key = muscleGroups.entries
          .firstWhere(
            (entry) => entry.value.contains(e.category),
        orElse: () => MapEntry('', []), // Default if no match is found.
      )
          .key;
      if (key == 'Upper Body') {
        upperBody++;
      } else if (key == 'Core') {
        core++;
      } else if (key == 'Lower Body') {
        lowerBody++;
      } else if (key == 'Back') {
        back++;
      }
    }
    if (upperBody == 0 && core == 0 && lowerBody == 0 && back == 0) {
      plan.url = "assets/images/clean.png";
      return;
    }
    Map<String, int> categoryCounts = {
      'Upper Body': upperBody,
      'Core': core,
      'Lower Body': lowerBody,
      'Back': back,
    };

    String maxCategory =
        categoryCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    switch (maxCategory) {
      case 'Upper Body':
        plan.url = "assets/images/upperbody.jpg";
        break;
      case 'Core':
        plan.url = "assets/images/core.jpg";
        break;
      case 'Lower Body':
        plan.url = "assets/images/lowerbody.jpg";
        break;
      case 'Back':
        plan.url = "assets/images/back.jpg";
        break;
      default:
        break;
    }
  }

  void pickSuggestedPlans(
      SocialProvider socialProvider, LoginProvider loginProvider) {
    suggestedPlans = [];
    int amountOfPlans = 10;
    int upperBody = 0, core = 0, lowerBody = 0, back = 0;

    upperBody = 0;
    core = 0;
    lowerBody = 0;
    back = 0;

    if (socialProvider.socialPlans.length <= amountOfPlans) {
      for (SocialPlan p in socialProvider.socialPlans) {
        if (p.plan.userID == loginProvider.appUser.id) {
          continue;
        }
        suggestedPlans.add(p.plan);
      }
    } else {
      for (PlanTile plan in plans) {
        if (plan.url.contains("core")) {
          core++;
        } else if (plan.url.contains("lowerbody")) {
          lowerBody++;
        } else if (plan.url.contains("upperbody")) {
          upperBody++;
        } else if (plan.url.contains("back")) {
          back++;
        }
      }
      int total = core + upperBody + lowerBody + back;
      double corePercentage = (core / total);
      double lowerBodyPercentage = (lowerBody / total);
      double upperBodyPercentage = (upperBody / total);
      double backPercentage = (back / total);
      List<Map<String, dynamic>> categories = [
        {'name': 'core', 'percentage': corePercentage},
        {'name': 'lowerBody', 'percentage': lowerBodyPercentage},
        {'name': 'upperBody', 'percentage': upperBodyPercentage},
        {'name': 'back', 'percentage': backPercentage},
      ];
      categories.sort((a, b) => b['percentage'].compareTo(a['percentage']));
      int remainingPlans = amountOfPlans;

      for (var category in categories) {
        int allocation = (category['percentage'] * amountOfPlans).floor();
        if (allocation > remainingPlans) {
          allocation = remainingPlans;
        }
        remainingPlans -= allocation;
        List<PlanTile> selectedPlans = plans
            .where((plan) {
          switch (category['name']) {
            case 'core':
              return plan.url.contains("core");
            case 'lowerBody':
              return plan.url.contains("lowerbody");
            case 'upperBody':
              return plan.url.contains("upperbody");
            case 'back':
              return plan.url.contains("back");
            default:
              return false;
          }
        })
            .take(allocation)
            .toList();
        for (PlanTile p in selectedPlans) {
          if (p.userID == loginProvider.appUser.id) {
            selectedPlans.remove(p);
          }
        }
        suggestedPlans.addAll(selectedPlans);
      }
    }
    notifyListeners();
  }

  void updatePlans(List<PlanTile> list, context) {
    _plans = list;
    for (PlanTile plan in plans) {
      decidePicture(plan);
    }
    final socialProvider = Provider.of<SocialProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    pickSuggestedPlans(socialProvider, loginProvider);
    notifyListeners();
  }

  List<ExerciseModel> transformToExerciseModel(
      List<PlanExercise> planExercises) {
    return planExercises.map((planExercise) {
      return ExerciseModel(
        name: planExercise.name,
        img: planExercise.imagePath,
        category: planExercise.category,
        exerciseDetails: ExerciseDetailsModel(
          reps: planExercise.rep,
          sets: planExercise.sets,
          weight: planExercise.weight,
        ),
        checked: planExercise.checked,
      );
    }).toList();
  }

  void updatePlan(int index,
      {String? newTitle,
        String? newSubtitle,
        List<String>? newDays,
        List<PlanExercise>? exercises}) async {
    if (index >= 0 && index < _plans.length) {
      final oldPlan = _plans[index];
      final updatedPlan = PlanTile(
        id: oldPlan.id,
        raters: {},
        userID: oldPlan.userID,
        index: oldPlan.index,
        title: newTitle ?? oldPlan.title,
        subTitle: newSubtitle ?? oldPlan.subTitle,
        url: oldPlan.url,
        cDate: oldPlan.cDate,
        exercises: exercises ?? oldPlan.exercises,
        isEditMode: oldPlan.isEditMode,
        days: newDays ?? oldPlan.days,
        rating: 0, // Update days
      );
      _plans[index] = updatedPlan;
      decidePicture(_plans[index]);
      notifyListeners();

      String? token = await getUserToken();
      late PlanModel res;
      if (token != null) {
        res = await _apiService.updatePlan(
            token,
            PlanModel(
                id: oldPlan.id,
                userID: oldPlan.userID,
                title: updatedPlan.title,
                subTitle: updatedPlan.subTitle,
                img: updatedPlan.url,
                creationDate: updatedPlan.cDate,
                days: updatedPlan.days,
                rating: 0,
                exercises: transformToExerciseModel(updatedPlan.exercises),
                isShared: false,
                raters: {}));
        if (res.id != null) {
          plans[index].id = res.id!;
          notifyListeners();
        }
      }
    }
  }

  void removePlan(int index) async {
    final deletedID = _plans[index].id;
    if (index >= 0 && index < _plans.length) {
      removeNotifications(index);
      _plans.removeAt(index);
      // Update indices
      for (int i = 0; i < _plans.length; i++) {
        _plans[i] = PlanTile(
          id: _plans[i].id,
          index: i,
          title: _plans[i].title,
          raters: _plans[i].raters,
          userID: _plans[i].userID,
          subTitle: _plans[i].subTitle,
          url: _plans[i].url,
          cDate: _plans[i].cDate,
          exercises: _plans[i].exercises,
          isEditMode: false,
          // Ensure isEditMode is set
          days: _plans[i].days,
          rating: _plans[i].rating,
        );
      }
      notifyListeners();
    }
    String? token = await getUserToken();
    if (token != null) {
      await _apiService.removePlan(token, deletedID);
    }
  }

  PlanTile? getPlanById(int id) {
    if (id >= 0 && id < _plans.length) {
      return _plans[id];
    }
    return null;
  }

  List<PlanExercise> getExercisesForPlan(int planId) {
    final plan = getPlanById(planId);
    if (plan != null) {
      return plan.exercises;
    } else {
      return [];
    }
  }

  void addExerciseToPlan(int planId, PlanExercise exercise) {
    final plan = getPlanById(planId);
    if (plan != null) {
      plan.exercises.add(exercise);
      notifyListeners();
    }
  }

  void removeExerciseFromPlan(int planId, PlanExercise exercise) {
    final plan = getPlanById(planId);
    if (plan != null) {
      plan.exercises.removeWhere((e) => e.name == exercise.name);
      notifyListeners();
    }
  }

  void updateExerciseInPlan(int planId, PlanExercise exercise) {
    final plan = getPlanById(planId);
    if (plan != null) {
      int index = plan.exercises.indexWhere((e) => e.name == exercise.name);
      if (index != -1) {
        plan.exercises[index] = exercise;
        notifyListeners();
      }
    }
  }

  void updatePlanExercises(int planId, List<PlanExercise> exercises) {
    final plan = getPlanById(planId);
    if (plan != null) {
      plan.exercises
        ..clear()
        ..addAll(exercises);
      notifyListeners();
    }
  }

  double getPlanProgress(int planId) {
    final plan = getPlanById(planId);
    if (plan != null && plan.exercises.isNotEmpty) {
      int totalExercises = plan.exercises.length;
      int checkedExercises = plan.exercises.where((e) => e.checked).length;
      return checkedExercises / totalExercises;
    }
    return 0.0;
  }

  // PlanStartWidget Logic
  bool isEditingPlan(int planId) => _isEditingPlan[planId] ?? false;

  void toggleEditingPlan(int planId) {
    _isEditingPlan[planId] = !(_isEditingPlan[planId] ?? false);
    notifyListeners();
  }

  bool isTimerRunning(int planId) => _isTimerRunning[planId] ?? false;

  StopWatchTimer getTimer(int planId) {
    if (!_timers.containsKey(planId)) {
      _timers[planId] = StopWatchTimer(mode: StopWatchMode.countUp);
    }
    return _timers[planId]!;
  }

  void startTimer(int planId) {
    getTimer(planId).onStartTimer();
    _isTimerRunning[planId] = true;
    notifyListeners();
  }

  void stopTimer(int planId) {
    getTimer(planId).onStopTimer();
    _isTimerRunning[planId] = false;
    notifyListeners();
  }

  void resetTimer(int planId) {
    getTimer(planId).onResetTimer();
    _isTimerRunning[planId] = false;
    notifyListeners();
  }

  void disposeTimer(int planId) {
    if (_timers.containsKey(planId)) {
      _timers[planId]!.dispose();
      _timers.remove(planId);
    }
  }

  // Logic for deleting an exercise
  void deleteExerciseFromPlan(int planId, PlanExercise exercise) {
    removeExerciseFromPlan(planId, exercise);
  }

  // Logic for checking/unchecking an exercise
  void toggleExerciseCheck(int planId, PlanExercise exercise, bool isChecked) {
    if (!isTimerRunning(planId)) {
      return;
    }
    exercise.checked = isChecked;
    updateExerciseInPlan(planId, exercise);
  }

  // Logic for expanding/collapsing exercises for inline editing/adding
  void toggleExerciseExpansion(int planId, String exerciseName) {
    _expandedExercises.putIfAbsent(planId, () => <String>{});
    if (_expandedExercises[planId]!.contains(exerciseName)) {
      _expandedExercises[planId]!.remove(exerciseName);
    } else {
      _expandedExercises[planId]!.add(exerciseName);
    }
    notifyListeners();
  }

  bool isExerciseExpanded(int planId, String exerciseName) {
    return _expandedExercises[planId]?.contains(exerciseName) ?? false;
  }

  // Method to close all expanded exercises for a plan
  void closeAllExpandedExercises(int planId) {
    if (_expandedExercises.containsKey(planId)) {
      _expandedExercises[planId]?.clear();
      notifyListeners();
    }
  }

  // Logic for adding/updating exercise with inline editing
  void addOrUpdateExerciseInPlan(int planId, PlanExercise exercise) {
    final plan = getPlanById(planId);
    if (plan == null) return;

    int index = plan.exercises.indexWhere((e) => e.name == exercise.name);
    if (index != -1) {
      // Update existing exercise
      plan.exercises[index] = exercise;
    } else {
      // Add new exercise
      plan.exercises.add(exercise);
    }
    notifyListeners();
  }

  // Logic for adding an exercise from PlanStartWidget
  Future<void> addExerciseToPlanFromStartWidget(
      BuildContext context, int planId) async {
    final plan = getPlanById(planId);
    if (plan == null) return;

    // Navigate to BuildPlanWidget or handle exercise addition here
    // Since BuildPlanWidget is a UI component, you might need to handle navigation here
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuildPlanWidget(plan: plan),
      ),
    );
  }

  void onPlanExecutionFinish(context, planId) async {
    final excModelList = addFinishedPlanToProgress(context, planId);
    final progressProvider =
    Provider.of<ProgressProvider>(context, listen: false);
    int finished = 1;

    for (var exercise in getPlanById(planId)!.exercises) {
      if (exercise.checked == false) {
        finished = 0;
        break;
      }
    }
    if (finished == 1) {
      progressProvider.handleFinishWorkout((this.getPlanById(planId))!);
    }
    final historyModel = savePlanToHistory(context, planId, finished);
    progressProvider.updateAchievements(historyModel);
    final List<HistoryModel> list = [];
    list.add(historyModel);
    PostStatsModel postModel = PostStatsModel(
        exercise: excModelList,
        history: list,
        year: DateTime.now().year,
        week: WorkoutProgramList.getWeekNumber(DateTime.now()),
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    String y = "";
    String? x = await getUserToken();
    if (x != null) {
      y = x;
    }
    final achievementModel =
    AchievementAdapter.generalAchievementsToAchievementModel(
        progressProvider.achievements);
    await _statsApiService.updateAchievement(y, achievementModel);
    await _statsApiService.addStats(y, postModel);

    for (var exercise in getPlanById(planId)!.exercises) {
      exercise.checked = false;
    }
    notifyListeners();
  }

  HistoryModel savePlanToHistory(context, planId, int finished) {
    final historyProvider =
    Provider.of<HistoryPageProvider>(context, listen: false);
    final calenderProvider =
    Provider.of<CalendarProvider>(context, listen: false);
    stopTimer(planId);
    String timerVal = StopWatchTimer.getDisplayTime(
        getTimer(planId).rawTime.value,
        hours: true,
        milliSecond: false);
    final historyModel = historyProvider.addExecutedPlan(
        getPlanById(planId)!, timerVal, finished);
    disposeTimer(planId);
    calenderProvider.addDate(DateTime.now());
    return historyModel;
  }

  List<ExerciseModel> addFinishedPlanToProgress(context, planId) {
    final List<ExerciseModel> exerciseList = [];
    final progressProvider =
    Provider.of<ProgressProvider>(context, listen: false);
    List<String> exL = progressProvider.excList!;
    for (var exercise in getPlanById(planId)!.exercises) {
      if (!exercise.checked) {
        continue;
      }

      ExerciseDetailsModel excDetails = ExerciseDetailsModel(
          reps: exercise.weight, sets: exercise.sets, weight: exercise.weight);
      ExerciseModel excModel = ExerciseModel(
          name: exercise.name,
          img: exercise.imagePath,
          category: exercise.category,
          exerciseDetails: excDetails,
          checked: exercise.checked);
      exerciseList.add(excModel);

      if (exL.contains(exercise.name)) {
        final indexExercise = progressProvider.progressData
            .indexWhere((data) => data.name == exercise.name);
        final indexWeek = progressProvider
            .progressData[indexExercise].dataByDateWeek
            .indexWhere((data) =>
        data.weekNum ==
            WorkoutProgramList.getWeekNumber(DateTime.now()));
        if (indexWeek != -1) {
          progressProvider
              .progressData[indexExercise].dataByDateWeek[indexWeek].dataByDate
              .add(DataByDate(
              weight: exercise.weight,
              sets: exercise.sets,
              reps: exercise.rep,
              date: DateTime.now()));
        } else {
          progressProvider.progressData[indexExercise].dataByDateWeek
              .add(DataByWeek(
              weekNum: WorkoutProgramList.getWeekNumber(DateTime.now()),
              dataByDate: [
                DataByDate(
                    weight: exercise.weight,
                    sets: exercise.sets,
                    reps: exercise.rep,
                    date: DateTime.now())
              ],
              year: DateTime.now().year));
        }
      } else {
        progressProvider.excList?.add(exercise.name);
        progressProvider.progressData
            .add(WorkoutProgramData(name: exercise.name, dataByDateWeek: [
          DataByWeek(
              weekNum: WorkoutProgramList.getWeekNumber(DateTime.now()),
              dataByDate: [
                DataByDate(
                    weight: exercise.weight,
                    sets: exercise.sets,
                    reps: exercise.rep,
                    date: DateTime.now())
              ],
              year: DateTime.now().year)
        ]));
      }
    }
    final list = WorkoutProgramList.listWorkout;
    progressProvider.notifyListeners();

    return exerciseList;
  }
}
