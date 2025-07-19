import 'package:IOFit/Adapters/ExerciseAdapter.dart';
import 'package:IOFit/Plans/plan_exercise.dart';
import 'package:IOFit/models/historymodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Plans/History.dart';
import '../Plans/PlanList/plan_data.dart';
import 'workout.dart';

class HistoryPageProvider with ChangeNotifier {
  List<ExecutedPlan> _history = [];

  List<ExecutedPlan> _filteredHistory = [];

  List<ExecutedPlan> get filteredHistory => _filteredHistory;

  List<ExecutedPlan> get history => _history;

  HistoryModel addExecutedPlan(
      PlanTile plan, String executionTime, int finished) {
    bool finish = false;
    if (finished == 1) {
      finish = true;
    }
    List<PlanExercise> copy = [];
    for (var exercise in plan.exercises) {
      copy.add(PlanExercise(name: exercise.name, imagePath: exercise.imagePath, category: exercise.category,
          rep: exercise.rep, sets: exercise.sets, weight: exercise.weight, checked: exercise.checked));
    }

    final newData = ExecutedPlan(
        id: _history.length.toString(),
        title: plan.title,
        exercises: copy,
        executionDate: DateFormat('dd.MM.yyyy').format(DateTime.now()),
        executionTime: executionTime,
        finished: finish);
    _history.insert(0, newData);

    final HistoryModel historyModel = HistoryModel(
        id: "",
        userID: "",
        title: plan.title,
        executionDate: DateFormat('dd.MM.yyyy').format(DateTime.now()),
        duration: executionTime,
        exercises: ExerciseAdapter.convertToExerciseModel(plan.exercises));

    return historyModel;
  }

  void updateHistory(List<ExecutedPlan> newList) {
    _history = newList;
    notifyListeners();
  }

  void reset() {
    _history = [];
    _filteredHistory = [];
    notifyListeners();
  }


  void changeFilterToAll() {
    _filteredHistory = _history;
  }

  List<ExecutedPlan> filterByDate(List<ExecutedPlan> plans, int daysAgo) {
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: daysAgo));

    return plans.where((plan) {
      final executionDate = DateFormat('dd.MM.yyyy').parse(plan.executionDate);
      return executionDate.isAfter(cutoffDate);
    }).toList();
  }

  List<ExecutedPlan> filterLastWeek(List<ExecutedPlan> plans) {
    return filterByDate(plans, 7);
  }

  List<ExecutedPlan> filterLastMonth(List<ExecutedPlan> plans) {
    return filterByDate(plans, 30);
  }

  List<ExecutedPlan> filterLastThreeMonths(List<ExecutedPlan> plans) {
    return filterByDate(plans, 90);
  }

  List<ExecutedPlan> filterLastSixMonths(List<ExecutedPlan> plans) {
    return filterByDate(plans, 180);
  }

  void handleClick(String clicked) {
    switch (clicked) {
      case 'All':
        {
          changeFilterToAll();
        }
        break;

      case '1W':
        {
          _filteredHistory = filterLastWeek(_history);
        }
        break;

      case '1M':
        {
          _filteredHistory = filterLastMonth(_history);
        }
        break;

      case '3M':
        {
          _filteredHistory = filterLastThreeMonths(_history);
        }
        break;
      case '6M':
        {
          _filteredHistory = filterLastSixMonths(_history);
        }
        break;
    }

  }
}
