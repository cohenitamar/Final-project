import 'package:json_annotation/json_annotation.dart';


part 'registerusermodel.g.dart';

@JsonSerializable()
class RegisterUserModel {
  final String picture;
  final String firstName;
  final String lastName;
  RegisterUserModel({
    required this.picture,
    required this.firstName,
    required this.lastName,
  });

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserModelToJson(this);

}
