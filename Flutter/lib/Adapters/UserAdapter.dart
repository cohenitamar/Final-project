

import 'package:IOFit/User/PersonalInformation.dart';
import 'package:IOFit/User/User.dart';
import 'package:IOFit/models/personalinformationmodel.dart';
import 'package:IOFit/models/usermodel.dart';

class UserAdapter{

  static PersonalInformation convertToPersonalInfo (UserModel user){
    List<Certification> listB = (user
        .personalInformation.certifications
        .map((a) => Certification(
        title: a.title, link: a.link))
        .toList());
    PersonalInformation info =
    PersonalInformation(
        height:
        user.personalInformation.height,
        weight:
        user.personalInformation.weight,
        bodyFat: user
            .personalInformation.bodyFat,
        trainingsPerWeek: user
            .personalInformation
            .trainingsPerWeek
            .toDouble(),
        doingAerobic: user
            .personalInformation
            .doingAerobic,
        age: user.personalInformation.age,
        gender:
        user.personalInformation.gender,
        occupation: user
            .personalInformation.occupation,
        experienceLevel: user
            .personalInformation
            .experienceLevel,
        certifications: listB,
        languages: user
            .personalInformation.languages,
        specializations: user
            .personalInformation
            .specializations,
        socialAccounts: user
            .personalInformation
            .socialAccounts);

    return info;
  }

  static AppUser convertToAppUser(UserModel user){
    final info = convertToPersonalInfo(user);
    AppUser newUser = AppUser(
      id: user.id,
        firstName:
        user.personalInformation.firstName,
        lastName:
        user.personalInformation.lastName,
        email: user.email,
        profilePicture:
        user.personalInformation.profilePic,
        info: info);
    return newUser;
  }
















}