import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull

import '../../exercise_list_widget.dart';
import '../PlanProvider.dart';
import '../plan_exercise.dart';
import '../PlanList/plan_data.dart'; // For PlanTile
import '../ExerciseListItem.dart'; // Adjust the import path as needed

class BuildPlanWidget extends StatefulWidget {
  final PlanTile plan;

  const BuildPlanWidget({Key? key, required this.plan}) : super(key: key);

  @override
  _BuildPlanWidgetState createState() => _BuildPlanWidgetState();
}

class _BuildPlanWidgetState extends State<BuildPlanWidget> {
  @override
  void initState() {
    super.initState();
    // No more calling planProvider.loadExercises()
    // We'll assume PlanProvider already has what it needs.
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context, listen: false);

    // Retrieve the current plan using the ID/index stored in widget.plan
    final PlanTile? currentPlan = planProvider.getPlanById(widget.plan.index);

    // If for some reason the plan is not found, show an error
    if (currentPlan == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Build Training Plan'),
        ),
        body: const Center(
          child: Text('Plan not found.'),
        ),
      );
    }

    // Otherwise, build the UI with the ExerciseListScreen
    return Scaffold(
      body: ExerciseListScreen(
        isSearch: false,
        title: 'Build Training Plan',
        itemBuilder: (context, exercise) {
          // Check if this exercise is in the plan
          final PlanExercise? planExercise = currentPlan.exercises
              .firstWhereOrNull((pe) => pe.name == exercise.name);

          // Check whether the exercise is expanded within this plan
          final bool isExpanded = planProvider.isExerciseExpanded(
            currentPlan.index,
            exercise.name,
          );

          return ExerciseListItem(
            planId: currentPlan.index,
            exercise: exercise,
            planExercise: planExercise, // Can be null if not yet added to plan
            isExpanded: isExpanded,
            isEditing: true,
            showSaveButton: true,
          );
        },
      ),
    );
  }
}
