// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registerusermodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserModel _$RegisterUserModelFromJson(Map<String, dynamic> json) =>
    RegisterUserModel(
      picture: json['picture'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );

Map<String, dynamic> _$RegisterUserModelToJson(RegisterUserModel instance) =>
    <String, dynamic>{
      'picture': instance.picture,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
    };
