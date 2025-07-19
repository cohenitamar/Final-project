import 'dart:convert';
import 'package:IOFit/SearchExercise/search_exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:provider/provider.dart';
import '../exercise_list_widget.dart';
import 'exercise_list_item.dart';
import 'exercise.dart';
import '../Exercise/exercise_widget.dart';

class SearchExerciseWidget extends StatelessWidget {
  const SearchExerciseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExerciseListScreen(
      isSearch: true,
      title: 'Search For Exercise',
      itemBuilder: (context, exercise) {
        return ExerciseListItem(exercise: exercise);
      },
    );
  }
}
