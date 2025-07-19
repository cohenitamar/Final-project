


import 'package:IOFit/models/historymodel.dart';

import '../Plans/PlanList/plan_data.dart';
import '../Plans/plan_exercise.dart';

class ExerciseAdapter{

  static List<ExerciseModel> convertToExerciseModel(List<PlanExercise> list){
    List<ExerciseModel> newList =[];
    list.forEach((element) {
      final elmDetails = ExerciseDetailsModel(reps: element.rep,
          sets: element.sets, weight: element.weight);
      final excModel = ExerciseModel(name: element.name, img: element.imagePath, category: element.category,
          exerciseDetails: elmDetails, checked: element.checked);
      newList.add(excModel);
    });
    return newList;


  }



}