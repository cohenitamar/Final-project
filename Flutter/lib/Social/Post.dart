// post_model.dart
import 'package:IOFit/Social/social_information.dart';

import '../User/User.dart';
class Post {
  String id;
  final String userID;
  final SocialInformation user;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.user,
    required this.userID,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.timestamp,
  });
}