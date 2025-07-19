
import '../models/historymodel.dart';
import '../Plans/History.dart';
import '../Plans/plan_exercise.dart';
class HistoryAdapter {
  static List<ExecutedPlan> convertHistoryToExecutedPlan(
      List<HistoryModel> historyList) {
    return historyList.map((history) {
      return ExecutedPlan(
        id: history.id,
        title: history.title,
        exercises: history.exercises.map((exercise) {
          return PlanExercise(
            name: exercise.name,
            imagePath: exercise.img,
            category: exercise.category,
            rep: exercise.exerciseDetails.reps,
            sets: exercise.exerciseDetails.sets,
            weight: exercise.exerciseDetails.weight,
            checked: exercise.checked,
          );
        }).toList(),
        executionDate: history.executionDate,
        executionTime: history.duration,
        // Assuming duration maps to executionTime
        finished: true, // You can set this based on your logic
      );
    }).toList();
  }
}