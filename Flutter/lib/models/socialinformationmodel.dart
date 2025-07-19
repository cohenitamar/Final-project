import 'package:IOFit/Social/social_information.dart';
import 'package:IOFit/models/personalinformationmodel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'socialinformationmodel.g.dart';

@JsonSerializable()
class SocialInformationModel {
  String firstName;
  String lastName;
  String profilePicture;
  int age;
  String gender;
  String occupation;
  String experienceLevel;
  List<CertificationModel> certifications;
  List<String> languages;
  List<String> specializations;
  Map<String, String> socialAccounts;

  SocialInformationModel({
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.experienceLevel,
    required this.certifications,
    required this.languages,
    required this.specializations,
    required this.socialAccounts, // Added to constructor
  });

  factory SocialInformationModel.fromJson(Map<String, dynamic> json) =>
      _$SocialInformationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialInformationModelToJson(this);


}
