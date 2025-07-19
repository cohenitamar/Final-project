import 'package:json_annotation/json_annotation.dart';

import 'historymodel.dart';

part 'planmodel.g.dart';

@JsonSerializable()
class PlanModel {
  @JsonKey(name: '_id')
  final String? id; // Made nullable
  final String? userID; // Made nullable
  final String title;
  final String subTitle;
  final String img;
  final String creationDate;
  final List<String> days;
  final num rating;
  final List<ExerciseModel>? exercises;
  final bool isShared;
  final Map<String, dynamic>? raters; // Made nullable

  PlanModel({
    required this.id,
    required this.userID,
    required this.title,
    required this.subTitle,
    required this.img,
    required this.creationDate,
    required this.days,
    required this.rating,
    required this.exercises,
    required this.isShared,
    required this.raters,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) =>
      _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);

  @override
  String toString() {
    return 'PlanModel(id: $id, userID: $userID, title: $title, subTitle: $subTitle, img: $img, creationDate: $creationDate, days: $days, rating: $rating, exercises: $exercises, isShared: $isShared, raters: $raters)';
  }
}
