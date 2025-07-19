
import 'package:json_annotation/json_annotation.dart';

import 'historymodel.dart';



part 'poststatsmodel.g.dart';

@JsonSerializable()
class PostStatsModel {
  final List<ExerciseModel> exercise;
  final List<HistoryModel> history;
  final int year;
  final int week;
  final String date;


  PostStatsModel({
    required this.exercise,
    required this.history,
    required this.year,required this.week,required this.date

  });

  factory PostStatsModel.fromJson(Map<String, dynamic> json) =>
      _$PostStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostStatsModelToJson(this);

}