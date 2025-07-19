import 'package:IOFit/Plans/plan_exercise.dart';

class ExecutedPlan{
  final String id;
  final String title;
  final List<PlanExercise> exercises;
  final String executionDate;
  final String executionTime;
  final bool finished;

  ExecutedPlan({
    required this.id,
    required this.title,
    required this.exercises,
    required this.executionDate,
    required this.executionTime,
    required this.finished,
  });
}