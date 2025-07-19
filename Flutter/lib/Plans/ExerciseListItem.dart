// ExerciseListItem.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart'; // For firstWhereOrNull
import '../SearchExercise/search_exercise_provider.dart';
import 'PlanProvider.dart';
import 'plan_exercise.dart';
import '../../SearchExercise/exercise.dart';

class ExerciseListItem extends StatefulWidget {
  final int planId;
  final Exercise? exercise;      // For BuildPlanWidget
  final PlanExercise? planExercise; // For BuildPlanWidget and PlanStartWidget
  final bool isEditing;
  final bool isExpanded;
  final bool social;
  final bool showSaveButton; // New parameter to control the Save/Add button

  const ExerciseListItem({
    Key? key,
    required this.planId,
    this.exercise,
    this.planExercise,
    this.isEditing = false,
    this.isExpanded = false,
    this.social = false,
    this.showSaveButton = false, // Default is false
  }) : super(key: key);

  @override
  _ExerciseListItemState createState() => _ExerciseListItemState();
}

class _ExerciseListItemState extends State<ExerciseListItem> {
  late TextEditingController setsController;
  late TextEditingController repsController;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();

    // For initial controller values, use planExercise if available; fallback to defaults.
    int sets = widget.planExercise?.sets ?? 1;
    int reps = widget.planExercise?.rep ?? 10;
    int weight = widget.planExercise?.weight ?? 10;

    setsController = TextEditingController(text: sets.toString());
    repsController = TextEditingController(text: reps.toString());
    weightController = TextEditingController(text: weight.toString());

    // Listeners to update exercise in the plan immediately upon changes
    setsController.addListener(_onSetsChanged);
    repsController.addListener(_onRepsChanged);
    weightController.addListener(_onWeightChanged);
  }

  @override
  void dispose() {
    setsController.dispose();
    repsController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void _onSetsChanged() {
    int sets = int.tryParse(setsController.text) ?? 1;
    _updateExercise(sets: sets);
  }

  void _onRepsChanged() {
    int reps = int.tryParse(repsController.text) ?? 10;
    _updateExercise(reps: reps);
  }

  void _onWeightChanged() {
    int weight = int.tryParse(weightController.text) ?? 0;
    _updateExercise(weight: weight);
  }

  void _updateExercise({int? sets, int? reps, int? weight}) {
    final planProvider = Provider.of<PlanProvider>(context, listen: false);

    // We must handle the case if both widget.exercise and widget.planExercise are null
    // If there's no valid name, we just skip updating.
    final String? name = widget.exercise?.name ?? widget.planExercise?.name;
    if (name == null) return;

    final String imagePath = widget.exercise?.imagePath ??
        widget.planExercise?.imagePath ??
        'assets/images/clean.png'; // Fallback
    final String category = widget.exercise?.category ??
        widget.planExercise?.category ??
        'Other'; // Fallback

    // We'll pull "checked" from the existing plan exercise if we can find it,
    // or fallback to widget.planExercise?.checked or false.
    final currentExercise = planProvider
        .getExercisesForPlan(widget.planId)
        .firstWhereOrNull((pe) => pe.name == name);

    final bool isChecked = currentExercise?.checked ??
        (widget.planExercise?.checked ?? false);

    PlanExercise updatedExercise = PlanExercise(
      name: name,
      imagePath: imagePath,
      category: category,
      sets: sets ?? currentExercise?.sets ?? 1,
      rep: reps ?? currentExercise?.rep ?? 10,
      weight: weight ?? currentExercise?.weight ?? 0,
      checked: isChecked,
    );

    planProvider.addOrUpdateExerciseInPlan(widget.planId, updatedExercise);
  }

  @override
  Widget build(BuildContext context) {
    const Color secondaryColor = Colors.white;
    final planProvider = Provider.of<PlanProvider>(context);

    // Determine the exercise name from either widget.exercise or widget.planExercise
    final String? name = widget.exercise?.name ?? widget.planExercise?.name;
    // If we have no name, just render nothing
    if (name == null) {
      return const SizedBox.shrink();
    }

    // Check if the plan already contains an exercise with this name
    final plan = planProvider.getPlanById(widget.planId);
    final PlanExercise? currentExercise =
    plan?.exercises.firstWhereOrNull((pe) => pe.name == name);

    // isAdded is true if we found an exercise in the plan
    final bool isAdded = (currentExercise != null);

    // If we have a currentExercise, we can use its image. Otherwise fallback to widget's planExercise or exercise
    final String imagePath = currentExercise?.imagePath ??
        widget.exercise?.imagePath ??
        widget.planExercise?.imagePath ??
        'assets/images/clean.png';

    // For display in ListTile
    final bool isExpanded = planProvider.isExerciseExpanded(widget.planId, name);

    // Prepare subtitle
    String subtitleText = '';
    if (isAdded && currentExercise != null) {
      subtitleText =
      'Sets: ${currentExercise.sets}, Reps: ${currentExercise.rep}';
      if (currentExercise.weight != 0) {
        subtitleText += ', Weight: ${currentExercise.weight}';
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white24,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            leading: Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Colors.grey.shade700,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: AssetImage(imagePath),
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontFamily: 'Readex Pro',
                color: secondaryColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: isAdded && !widget.social
                ? Text(
              subtitleText,
              style: const TextStyle(
                color: secondaryColor,
                fontSize: 14.0,
              ),
            )
                : null,
            trailing: widget.isEditing
                ? IconButton(
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
              onPressed: () {
                planProvider.toggleExerciseExpansion(widget.planId, name);
              },
            )
                : (isAdded && !widget.social && currentExercise != null)
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                  value: currentExercise.checked,
                  onChanged: (bool? value) {
                    if (value == null) return;
                    planProvider.toggleExerciseCheck(
                      widget.planId,
                      currentExercise,
                      value,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info, color: Colors.white),
                  onPressed: () {
                    final searchProvider =
                    Provider.of<SearchExerciseProvider>(
                      context,
                      listen: false,
                    );

                    // If the user has an exercise list,
                    // find the matching exercise by name
                    final e = searchProvider.eList.firstWhere(
                          (item) => item.name == currentExercise.name,
                    );

                    searchProvider.handleExerciseClick(context, e);
                  },
                ),
              ],
            )
                : null,
            onTap: widget.isEditing
                ? () {
              planProvider.toggleExerciseExpansion(widget.planId, name);
            }
                : null,
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Sets, Reps, Weight Input Fields
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: setsController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Sets',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: repsController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Reps',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Weight',
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (isAdded && widget.isEditing && currentExercise != null)
                        TextButton(
                          onPressed: () {
                            planProvider.deleteExerciseFromPlan(
                              widget.planId,
                              currentExercise,
                            );
                            planProvider.toggleExerciseExpansion(
                                widget.planId, name);
                          },
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      if (widget.showSaveButton)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            // Grab the user inputs
                            int sets =
                                int.tryParse(setsController.text) ?? 1;
                            int reps =
                                int.tryParse(repsController.text) ?? 10;
                            int weight =
                                int.tryParse(weightController.text) ?? 0;

                            // Get category from whichever is valid
                            final String category = widget.exercise?.category ??
                                widget.planExercise?.category ??
                                'Other';

                            // Create or update the exercise
                            final newExercise = PlanExercise(
                              name: name,
                              imagePath: imagePath,
                              category: category,
                              sets: sets,
                              rep: reps,
                              weight: weight,
                              checked: currentExercise?.checked ??
                                  widget.planExercise?.checked ??
                                  false,
                            );

                            planProvider.addOrUpdateExerciseInPlan(
                              widget.planId,
                              newExercise,
                            );

                            planProvider.toggleExerciseExpansion(
                              widget.planId,
                              name,
                            );
                          },
                          child: Text(
                            isAdded ? 'Save' : 'Add',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
