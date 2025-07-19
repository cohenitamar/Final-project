import 'package:flutter/material.dart';
import '../SearchExercise/exercise.dart';
import '../SearchExercise/exercise_list_item.dart';

class PredictionScreen extends StatelessWidget {
  final String predictedMachineName;
  final List<Exercise> exercises;

  const PredictionScreen({
    Key? key,
    required this.predictedMachineName,
    required this.exercises,
  }) : super(key: key);

  /// Convert the machine’s "internal" name to a nicer display name
  String getDisplayName(String predictedName) {
    switch (predictedName.toLowerCase()) {
      case 'bench_press':
        return 'Bench Press';
      case 'leg_press':
        return 'Leg Press';
      case 'pec_deck':
        return 'Pec Deck';
    // Add more cases as needed
      default:
      // Capitalize the first letter, for any unknown name
        return predictedName[0].toUpperCase() + predictedName.substring(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedMachineName = getDisplayName(predictedMachineName);
    const Color backgroundColor = Color(0xFF1A1A2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 4,
        title: Text(
          'Prediction: $displayedMachineName',
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // Make the back icon (on Android) white
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Use a Column that has:
      // 1) A fixed-height container for the machine image
      // 2) An Expanded for the scrolling list of exercises
      body: Column(
        children: [
          // (1) Image container
          Container(
            height: 200,
            width: double.infinity,
            child: Image.asset(
              'assets/images/$predictedMachineName.png',
              fit: BoxFit.contain,
              color: Colors.white, // Make sure it’s visible on the dark background
            ),
          ),
          Divider(color: Colors.white24),

          // (2) Expanded for your exercise list
          Expanded(
            child: ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExerciseListItem(exercise: exercise),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
