

import '../Social/SocialPlan.dart';
import '../models/historymodel.dart';
import '../models/planmodel.dart';
import '../Plans/PlanList/plan_data.dart';
import '../Plans/plan_exercise.dart';



class PlanAdapter{

  static List<PlanTile> convertPlanModelToPlanTile(List<PlanModel> plans,
      bool isEditMode) {
    final a = plans
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key; // The position in the list
      final plan = entry.value; // The PlanModel object
      return PlanTile(
        id: plan.id!,
        userID: plan.userID!,
        title: plan.title,
        subTitle: plan.subTitle,
        url: plan.img,
        exercises: plan.exercises!.map((exercise) {
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
        index: index,
        // Use the index as the position in the list
        cDate: plan.creationDate,
        isEditMode: isEditMode,
        days: plan.days,
        rating: plan.rating.toInt(),
        raters: plan.raters == null ? {} : plan.raters!,
      );
    }).toList();
    return a;
  }

  static PlanModel convertPlanTileToPlanModel(PlanTile planTile) {
    return PlanModel(
      id: planTile.id,
      userID: planTile.userID,
      title: planTile.title,
      subTitle: planTile.subTitle,
      img: planTile.url, // Assuming 'url' in PlanTile corresponds to 'img' in PlanModel
      creationDate: planTile.cDate, // Assuming 'cDate' is the same as 'creationDate'
      days: planTile.days,
      rating: planTile.rating.toDouble(), // Ensures numeric consistency
      exercises: planTile.exercises.map((exercise) {
        return ExerciseModel(
          name: exercise.name,
          img: exercise.imagePath,
          category: exercise.category,
          exerciseDetails: ExerciseDetailsModel(
            reps: exercise.rep, // Renamed to 'reps'
            sets: exercise.sets,
            weight: exercise.weight,
          ),
          checked: exercise.checked,
        );
      }).toList(),
      isShared: planTile.isEditMode, // Assuming 'isEditMode' represents 'isShared'
      raters: planTile.raters,
    );
  }





}