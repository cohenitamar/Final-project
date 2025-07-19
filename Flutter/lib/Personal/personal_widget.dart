import 'dart:io'; // Import for File handling
import 'package:IOFit/Personal/CertificationsSection.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../User/PersonalInformation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../Social/Post.dart';
import '../User/user_db.dart';
import '../file_handler.dart';
import 'DetailCard.dart';
import 'EditableChips.dart';
import 'PersonalProvider.dart';
import 'SliderCard.dart';
import 'SocialNetworksSection.dart';

class PersonalWidget extends StatefulWidget {
  final bool isEditable;

  const PersonalWidget({super.key, this.isEditable = true});

  @override
  State<PersonalWidget> createState() => _PersonalWidgetState();
}

/// why you created var iseditable if you dont change him.
/// why need advertizment here
class _PersonalWidgetState extends State<PersonalWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontFamily: 'Readex Pro',
      color: Colors.white,
      fontSize: 16.0,
      letterSpacing: 0.0,
      fontWeight: FontWeight.w500,
    );
    final provider = Provider.of<PersonalProvider>(context, listen: true);

    List<Widget> contentWidgets = [
      // Profile Picture and Name
      Column(
        children: [
          GestureDetector(
            onTap: provider.isEditing
                ? () => provider.changeProfilePicture(context)
                : null,
            child: CircleAvatar(
              radius: 60.0,
              backgroundImage:
                  Utility.getImageProvider(provider.user.profilePicture),
              child: provider.isEditing
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black45,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            '${provider.user.firstName} ${provider.user.lastName}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          provider.isEditing
              ? TextField(
                  controller: provider.occupationController,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 18.0),
                  decoration: InputDecoration(
                    hintText: 'Occupation',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                )
              : Text(
                  provider.user.info.occupation,
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
        valueWidget: provider.isEditing
            ? TextField(
                controller: provider.ageController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.grey.shade400),
                decoration: InputDecoration(
                  hintText: 'Age',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              )
            : Text(
                '${provider.user.info.age} years',
                style: TextStyle(color: Colors.grey.shade400),
              ),
      ),
      DetailCard(
        icon: Icons.person,
        title: 'Gender',
        valueWidget: provider.isEditing
            ? TextField(
                controller: provider.genderController,
                style: TextStyle(color: Colors.grey.shade400),
                decoration: InputDecoration(
                  hintText: 'Gender',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              )
            : Text(
                provider.user.info.gender,
                style: TextStyle(color: Colors.grey.shade400),
              ),
      ),
      DetailCard(
        icon: Icons.work_outline,
        title: 'Occupation',
        valueWidget: provider.isEditing
            ? TextField(
                controller: provider.occupationController,
                style: TextStyle(color: Colors.grey.shade400),
                decoration: InputDecoration(
                  hintText: 'Occupation',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              )
            : Text(
                provider.user.info.occupation,
                style: TextStyle(color: Colors.grey.shade400),
              ),
      ),
      DetailCard(
        icon: Icons.fitness_center,
        title: 'Experience Level',
        valueWidget: provider.isEditing
            ? TextField(
                controller: provider.experienceLevelController,
                style: TextStyle(color: Colors.grey.shade400),
                decoration: InputDecoration(
                  hintText: 'Experience Level',
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              )
            : Text(
                provider.user.info.experienceLevel,
                style: TextStyle(color: Colors.grey.shade400),
              ),
      ),
      DetailCard(
        icon: Icons.language,
        title: 'Languages',
        valueWidget: provider.isEditing
            ? EditableChips(
                items: provider.user.info.languages,
                onAdd: (value) =>
                    provider.addToList(provider.user.info.languages, value),
                onDelete: (value) => provider.deleteFromList(
                    provider.user.info.languages, value))
            : Text(
                provider.user.info.languages.join(', '),
                style: TextStyle(color: Colors.grey.shade400),
              ),
      ),
      DetailCard(
        icon: Icons.star_border,
        title: 'Specializations',
        valueWidget: provider.isEditing
            ? EditableChips(
                items: provider.user.info.specializations,
                onAdd: (value) => provider.addToList(
                    provider.user.info.specializations, value),
                onDelete: (value) => provider.deleteFromList(
                    provider.user.info.specializations, value))
            : Text(
                provider.user.info.specializations.join(', '),
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
          parentType: "personal",
          certifications: provider.user.info.certifications),
      SizedBox(height: 32.0),
      // Social Networks Section
      Text(
        'Social Networks',
        style: labelStyle.copyWith(fontSize: 20.0),
      ),
      SizedBox(height: 16.0),
      SocialNetworksSection(
          parentType: "personal",
          socialAccounts: provider.user.info.socialAccounts),
    ];

    widget.isEditable
        ? contentWidgets.addAll([
            SizedBox(height: 32.0),
            // Physical Attributes Section
            Text(
              'Physical Attributes',
              style: labelStyle.copyWith(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            // Height Slider
            SliderCard(
              title: 'Height',
              value: provider.user.info.height,
              unit: 'cm',
              min: 100.0,
              max: 220.0,
              divisions: 120,
              onChanged: provider.isEditing
                  ? (newValue) => provider.changeHeight(newValue)
                  : null,
            ),
            // Weight Slider
            SliderCard(
              title: 'Weight',
              value: provider.user.info.weight,
              unit: 'kg',
              min: 30.0,
              max: 150.0,
              divisions: 120,
              onChanged: provider.isEditing
                  ? (newValue) => provider.changeWeight(newValue)
                  : null,
            ),
            // Body Fat Slider
            SliderCard(
              title: 'Body Fat',
              value: provider.user.info.bodyFat,
              unit: '%',
              min: 5.0,
              max: 50.0,
              divisions: 45,
              onChanged: provider.isEditing
                  ? (newValue) => provider.changeBodyFat(newValue)
                  : null,
            ),
            SizedBox(height: 32.0),
            // BMI Display
            Card(
              color: const Color(0xFF0A2A35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey.shade700),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.shield,
                  color: provider.getShieldColor(provider.bmiValue),
                  size: 40.0,
                ),
                title: Text(
                  'BMI',
                  style: labelStyle,
                ),
                subtitle: Text(
                  provider.bmiValue.toStringAsFixed(1),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Trainings per Week Slider
          ])
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF062029),
      appBar: AppBar(
        backgroundColor: const Color(0xFF062029),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
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
        actions: widget.isEditable
            ? [
                IconButton(
                  icon: Icon(
                    provider.isEditing ? Icons.check : Icons.edit,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () => provider.handleEditClick(context),
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: contentWidgets,
        ),
      ),
    );
  }
}
