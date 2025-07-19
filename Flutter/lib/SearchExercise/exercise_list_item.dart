import 'dart:convert';
import 'package:IOFit/SearchExercise/search_exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:provider/provider.dart';
import '../Homepage/homepage_provider.dart';
import '../exercise_list_widget.dart';
import 'exercise.dart';
import '../Exercise/exercise_widget.dart';


class ExerciseListItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseListItem({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider =
    Provider.of<SearchExerciseProvider>(context, listen: true);
    return InkWell(
      onTap: () {
        // Navigate to Exercise Details
        searchProvider.handleExerciseClick(context, exercise);
      },
      child: Container(
        height: 110.0,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
          child: Row(
            children: [
              // Exercise Image
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.grey.shade700,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: AssetImage(exercise.imagePath),
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              // Exercise Name
              Expanded(
                child: Text(
                  exercise.name,
                  style: const TextStyle(
                    fontFamily: 'Readex Pro',
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
