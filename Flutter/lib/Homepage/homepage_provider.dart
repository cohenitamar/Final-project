import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../SearchExercise/exercise.dart';
import '../SearchExercise/search_exercise_provider.dart'; // <-- Use your SearchExerciseProvider
import '../User/User.dart';
import '../User/user_db.dart';

class HomepageProvider with ChangeNotifier {
  late AppUser _user;

  AppUser get user => _user;

  void updateUser(AppUser user) {
    _user = user;
    notifyListeners();
  }


  List<Exercise> get filteredWorkouts => _filteredWorkouts;
  List<Exercise> get allWorkouts => _allWorkouts;


  void reset() {
    _filteredWorkouts = [];
    _allWorkouts = [];
  }


  // 6) Save to local storage
  Future<void> saveAllWorkoutsToLocal() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert each Exercise to a Map, then to a List
    final List<Map<String, dynamic>> listMap =
    _allWorkouts.map((e) => e.toMap()).toList();

    // Encode the list of maps as JSON
    final String encoded = jsonEncode(listMap);

    // Save it in SharedPreferences
    await prefs.setString('${user.id}allWorkouts', encoded);
  }

  // 7) Load from local storage
  Future<void> loadAllWorkoutsFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the JSON string (if any)
    final String? storedJson = prefs.getString('${user.id}allWorkouts');

    if (storedJson != null) {
      // Decode it into a List of dynamic
      final List<dynamic> decodedList = jsonDecode(storedJson);

      // Convert each dynamic map to an Exercise
      _allWorkouts = decodedList
          .map((item) => Exercise.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      _allWorkouts = [];
    }

    _filteredWorkouts = _allWorkouts;
  }


  void addWorkout(Exercise e, context) {
    _allWorkouts.removeWhere((item) => item.name == e.name);

    _allWorkouts.insert(0, e);

    if (_allWorkouts.length > 10) {
      _allWorkouts.removeLast();
    }

    filterWorkouts(choiceChipsValue, context);

    saveAllWorkoutsToLocal();

  }

  String choiceChipsValue = 'All';
  List<Exercise> _filteredWorkouts = [];
  List<Exercise> _allWorkouts = [];

  // Categories List
  final List<String> categories = [
    'All',
    'Abdominals',
    'Abductors',
    'Biceps',
    'Calves',
    'Chest',
    'Forearms',
    'Glutes',
    'Hamstrings',
    'Lats',
    'Lower Back',
    'Middle Back',
    'Neck',
    'Quadriceps',
    'Shoulders',
    'Traps',
    'Triceps',
  ];

  // Loading state
  bool _isLoading = true; // Initialize as true
  bool get isLoading => _isLoading;

  // Greeting message based on time of day
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 19) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Filter the exercises by category
  void filterWorkouts(String selectedCategory, BuildContext context) {


    final allExercises = allWorkouts;
    choiceChipsValue = selectedCategory;

    if (selectedCategory == 'All') {
      _filteredWorkouts = allExercises;
    } else {
      _filteredWorkouts = allExercises
          .where((exercise) => exercise.category == selectedCategory)
          .toList();
    }

    notifyListeners();
  }








}
