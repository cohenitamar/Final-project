// PlanStartWidget.dart

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:provider/provider.dart';
import '../PlanProvider.dart';
import '../plan_exercise.dart';
import '../ExerciseListItem.dart'; // Adjust the import path as needed

class PlanStartWidget extends StatelessWidget {
  final int planId; // Use planId instead of exercises list

  const PlanStartWidget({Key? key, required this.planId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the plan and exercises from the provider
    final planProvider = Provider.of<PlanProvider>(context);
    final plan = planProvider.getPlanById(planId);

    // Handle null plan scenario
    if (plan == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Plan not found'),
        ),
        body: const Center(
          child: Text('The plan could not be found.'),
        ),
      );
    }

    final exercises = plan.exercises..sort((a, b) => a.name.compareTo(b.name));

    // Define custom colors and text styles
    const Color primaryColor = Color(0xFF062029);
    const Color accentColor = Color(0xFFF29C62);
    const Color textColor = Colors.white;

    TextStyle headlineStyle = const TextStyle(
      fontFamily: 'Outfit',
      color: textColor,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final TextStyle labelMediumStyle = TextStyle(
      fontFamily: 'Readex Pro',
      color: textColor.withOpacity(0.7),
      fontSize: 14.0,
    );

    final isEditing = planProvider.isEditingPlan(planId);
    final isTimerRunning = planProvider.isTimerRunning(planId);
    final timer = planProvider.getTimer(planId);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30.0),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.title, style: headlineStyle),
                Text('Created on ${plan.cDate}', style: labelMediumStyle),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.done : Icons.edit,
              size: 30.0,
            ),
            onPressed: () {
              planProvider.toggleEditingPlan(planId);
              // Close all expanded exercises when exiting edit mode
              if (!planProvider.isEditingPlan(planId)) {
                planProvider.closeAllExpandedExercises(planId);
                // Update the plan with the new exercises
                planProvider.updatePlan(planId, exercises: plan.exercises);
              }
            },
            tooltip: isEditing ? 'Done' : 'Edit Plan',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Bar
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearPercentIndicator(
                  percent: planProvider.getPlanProgress(planId),
                  lineHeight: 12.0,
                  animation: true,
                  animateFromLastPercent: true,
                  progressColor: accentColor,
                  backgroundColor: Colors.grey[300],
                  barRadius: const Radius.circular(6.0),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Exercises',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    color: textColor,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          // Exercise List
          Expanded(
            child: exercises.isEmpty
                ? Center(
              child: Text(
                'No exercises found.',
                style: labelMediumStyle,
              ),
            )
                : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                PlanExercise exercise = exercises[index];
                final isExpanded = planProvider.isExerciseExpanded(
                    planId, exercise.name);
                return ExerciseListItem(
                  planId: planId,
                  exercise: null, // Not needed in PlanStartWidget
                  planExercise: exercise,
                  isEditing: isEditing,
                  isExpanded: isExpanded,
                );
              },
            ),
          ),
          // Timer Bar or Add Button
          isEditing
              ? SafeArea(
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade700),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 36.0, // Adjust size if necessary
                  ),
                  onPressed: () {
                    planProvider.closeAllExpandedExercises(planId);
                    planProvider.addExerciseToPlanFromStartWidget(
                        context, planId);
                  },
                ),
              ),
            ),
          )
              : SafeArea(
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade700),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timer Display
                  StreamBuilder<int>(
                    stream: timer.rawTime,
                    initialData: 0,
                    builder: (context, snapshot) {
                      final displayTime = StopWatchTimer.getDisplayTime(
                        snapshot.data!,
                        hours: true,
                        milliSecond: false,
                      );
                      return Text(
                        displayTime,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          color: textColor,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  // Timer Controls
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isTimerRunning
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: Colors.green,
                          size: 36.0, // Adjusted size
                        ),
                        onPressed: () {
                          if (isTimerRunning) {
                            planProvider.stopTimer(planId);
                          } else {
                            planProvider.startTimer(planId);
                          }
                        },
                        tooltip: isTimerRunning
                            ? 'Pause Timer'
                            : 'Start Timer',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.stop_circle,
                          color: Colors.red,
                          size: 36.0, // Adjusted size
                        ),
                        onPressed: () {
                          planProvider.resetTimer(planId);
                        },
                        tooltip: 'Stop Timer',
                      ),
                      IconButton(
                        icon: Image.asset(
                          "assets/images/flag.png",
                          width: 36.0, // Adjusted size
                          height: 36.0,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (planProvider.getTimer(planId).rawTime.value ==
                              0) {
                            return;
                          }
                          // Check if not all exercises are checked
                          if (exercises.any((exercise) => !exercise.checked)) {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Finish Plan?'),
                                  content: const Text(
                                      'You have not completed all exercises. Do you still want to finish the plan execution?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        planProvider.onPlanExecutionFinish(context, planId);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // All exercises are checked
                            planProvider.onPlanExecutionFinish(context, planId);
                          }
                        },
                        tooltip: 'Finish Plan',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
