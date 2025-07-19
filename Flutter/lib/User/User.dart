import 'PersonalInformation.dart';
import '../Social/Post.dart';

class AppUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  String profilePicture;
  final PersonalInformation info;
  final bool isPersonalTrainer;
  final Post? advertisement;

  AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
    required this.info,
    this.isPersonalTrainer = false,
    this.advertisement,
  });
}
