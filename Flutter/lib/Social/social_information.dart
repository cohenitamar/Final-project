import 'dart:typed_data';

import '../User/PersonalInformation.dart';

class SocialInformation {
  String firstName;
  String lastName;
  String profilePicture;
  Uint8List decodedProfilePicture;
  int age;
  String gender;
  String occupation;
  String experienceLevel;
  List<Certification> certifications; // Updated to use Certification objects
  List<String> languages;
  List<String> specializations;
  Map<String, String> socialAccounts; // Added social accounts

  SocialInformation({
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.decodedProfilePicture,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.experienceLevel,
    required this.certifications,
    required this.languages,
    required this.specializations,
    required this.socialAccounts, // Added to constructor
  });
}