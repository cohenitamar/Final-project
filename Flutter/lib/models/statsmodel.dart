import 'package:IOFit/models/progressmodel.dart';
import 'package:json_annotation/json_annotation.dart';

import 'historymodel.dart';



part 'statsmodel.g.dart';

@JsonSerializable()
class StatsModel {
  final List<ProgressModel> progress;
  final List<HistoryModel> history;

  StatsModel({
    required this.progress,
    required this.history,

  });

  factory StatsModel.fromJson(Map<String, dynamic> json) =>
      _$StatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatsModelToJson(this);

}