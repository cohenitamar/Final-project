import 'dart:io'; // Import for File handling
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../file_handler.dart';
import 'social_information.dart';
import '../User/PersonalInformation.dart';
import '../Personal/DetailCard.dart';
import '../Personal/CertificationsSection.dart';
import '../Personal/SocialNetworksSection.dart';

class SocialPersonalWidget extends StatelessWidget {
  final SocialInformation user;

  const SocialPersonalWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontFamily: 'Readex Pro',
      color: Colors.white,
      fontSize: 16.0,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w500,
    );

    List<Widget> contentWidgets = [
      // Profile Picture and Name
      Column(
        children: [
          CircleAvatar(
            radius: 60.0,
            backgroundImage:  MemoryImage(user.decodedProfilePicture),
          ),
          SizedBox(height: 16.0),
          Text(
            '${user.firstName} ${user.lastName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            user.occupation,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
      SizedBox(height: 32.0),
      // Personal Details Section
      Text(
        'Personal Details',
        style: labelStyle.copyWith(fontSize: 20.0),
      ),
      SizedBox(height: 16.0),
      DetailCard(
        icon: Icons.cake,
        title: 'Age',
        valueWidget: Text(
          '${user.age} years',
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      DetailCard(
        icon: Icons.person,
        title: 'Gender',
        valueWidget: Text(
          user.gender,
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      DetailCard(
        icon: Icons.work_outline,
        title: 'Occupation',
        valueWidget: Text(
          user.occupation,
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      DetailCard(
        icon: Icons.fitness_center,
        title: 'Experience Level',
        valueWidget: Text(
          user.experienceLevel,
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      DetailCard(
        icon: Icons.language,
        title: 'Languages',
        valueWidget: Text(
          user.languages.join(', '),
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      DetailCard(
        icon: Icons.star_border,
        title: 'Specializations',
        valueWidget: Text(
          user.specializations.join(', '),
          style: TextStyle(color: Colors.grey.shade400),
        ),
      ),
      SizedBox(height: 32.0),
      // Certifications Section
      Text(
        'Certifications',
        style: labelStyle.copyWith(fontSize: 20.0),
      ),
      SizedBox(height: 16.0),
      CertificationsSection(
          parentType: "social", certifications: user.certifications),
      SizedBox(height: 32.0),
      // Social Networks Section
      Text(
        'Social Networks',
        style: labelStyle.copyWith(fontSize: 20.0),
      ),
      SizedBox(height: 16.0),
      SocialNetworksSection(
          parentType: "social", socialAccounts: user.socialAccounts),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF062029),
      appBar: AppBar(
        backgroundColor: const Color(0xFF062029),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 8.0),
            Text(
              'Personal Information',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.white,
                fontSize: 24.0,
                letterSpacing: 0.0,
              ),
            ),
          ],
        ),
        actions: null, // Removed edit icon
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: contentWidgets,
        ),
      ),
    );
  }

  // Helper method to get the image provider
  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return NetworkImage(imagePath);
    } else if (imagePath.isNotEmpty) {
      return FileImage(File(imagePath));
    } else {
      return AssetImage('assets/default_profile.png');
    }
  }
}
