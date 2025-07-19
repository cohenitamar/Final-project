import 'dart:convert';
import 'package:IOFit/Homepage/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:provider/provider.dart';
import '../exercise_list_widget.dart';
import 'exercise.dart';
import '../Exercise/exercise_widget.dart';

class SearchExerciseProvider with ChangeNotifier {
  List<Exercise> _eList = [];

  List<Exercise> get eList => _eList;

  Future<void> loadExercises() async {
    eList.clear();
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filter to get all .gif files under assets/dataset/
    final datasetAssets = manifestMap.keys
        .where((String key) =>
            key.startsWith('assets/dataset/') && key.endsWith('.gif'))
        .toList();

    for (String assetPath in datasetAssets) {
      if (assetPath.contains('_fullsize')) continue; // Skip fullsize GIFs
      final fileName = assetPath.split('/').last;
      final fileNameWithoutExtension =
          fileName.substring(0, fileName.length - 4); // Remove '.gif'

      final parts = fileNameWithoutExtension.split('_');
      String category = parts[0];
      if (category.endsWith("Back")) {
        category = category.replaceFirst("Back", " Back");
      }
      final exerciseParts = parts.sublist(1);
      final String exerciseName = exerciseParts.join(' ');
      final String exerciseFolderName = exerciseParts.join('_');

      String fullSizeImagePath = assetPath.replaceAll('.gif', '_fullsize.gif');
      String instructions = await rootBundle
          .loadString('assets/dataset/$exerciseFolderName/instructions.txt');
      String muscles = 'assets/dataset/$exerciseFolderName/muscles.jpg';
      String machine;
      try {
        machine = await rootBundle
            .loadString('assets/dataset/$exerciseFolderName/machine.txt');
      } catch (e) {
        machine = "";
      }
      _eList.add(Exercise(
          name: exerciseName[0] + exerciseName.substring(1).toLowerCase(),
          imagePath: assetPath,
          category: category,
          fullSizeImagePath: fullSizeImagePath,
          instructions: instructions,
          muscles: muscles,
          machine: machine));
    }

    _eList.sort((a, b) => a.name.compareTo(b.name));
  }


  void reset() {
    _eList = [];
    notifyListeners();
  }


  void handleExerciseClick(BuildContext context, Exercise exercise) {
    final homepageProvider =
    Provider.of<HomepageProvider>(context, listen: false);
    homepageProvider.addWorkout(exercise, context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseWidget(
          exercise: exercise,
        ),
      ),
    );
  }
}
