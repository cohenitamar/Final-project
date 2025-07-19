// PersonalInformation.dart

class Certification {
  String title;
  String link; // Local file path to the PDF

  Certification({required this.title, required this.link});
}

class PersonalInformation {
  double height;
  double weight;
  double bodyFat;
  double trainingsPerWeek;
  bool doingAerobic;
  int age;
  String gender;
  String occupation;
  String experienceLevel;
  List<Certification> certifications; // Updated to use Certification objects
  List<String> languages;
  List<String> specializations;
  Map<String, String> socialAccounts; // Added social accounts

  PersonalInformation({
    required this.height,
    required this.weight,
    required this.bodyFat,
    required this.trainingsPerWeek,
    required this.doingAerobic,
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
