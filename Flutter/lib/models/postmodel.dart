import 'package:IOFit/Social/social_information.dart';
import 'package:IOFit/models/socialinformationmodel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postmodel.g.dart';

@JsonSerializable()
class PostModel {
  @JsonKey(name: '_id')
  final String id;
  final String userID;
  final String title;
  final String content;
  final String img;
  final String creationDate;

  PostModel({
    required this.id,
    required this.userID,
    required this.title,
    required this.content,
    required this.img,
    required this.creationDate,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);

  @override
  String toString() {
    return 'PostModel(id: $id, userID: $userID, title: $title, content: $content, img: $img, creationDate: $creationDate)';
  }
}
