import 'package:IOFit/Social/social_information.dart';
import 'package:IOFit/models/socialinformationmodel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fetchpostsmodel.g.dart';

@JsonSerializable()
class FetchPostModel {
  @JsonKey(name: '_id')
  final String id;
  final String userID;
  final SocialInformationModel user;
  final String title;
  final String content;
  final String img;
  final String creationDate;

  FetchPostModel({
    required this.id,
    required this.userID,
    required this.title,
    required this.user,
    required this.content,
    required this.img,
    required this.creationDate,
  });

  factory FetchPostModel.fromJson(Map<String, dynamic> json) =>
      _$FetchPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$FetchPostModelToJson(this);


}
