import 'dart:convert';
import 'dart:typed_data';
import 'package:IOFit/Progress/ProgressProvider.dart';
import 'package:IOFit/models/personalinformationmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart'; // <--- Import this for Clipboard
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // You can remove if not needed for anything else
import '../Adapters/AchievmentAdapter.dart';
import '../User/PersonalInformation.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../Social/Post.dart';
import 'package:http/http.dart' as http;
import '../User/User.dart';
import '../User/user_db.dart';
import '../api/plan_api_service.dart';
import '../api/stats_api_service.dart';
import '../api/user_api_service.dart';
import 'PDFViewerPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'BottomSheetWidget.dart';
import '../file_handler.dart';

class PersonalProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  late final UserApiService _apiService = UserApiService(_dio);
  late final StatsApiService _statsApiService = StatsApiService(_dio);

  double _bmiValue = 0.0;
  bool _isEditing = false;
  late TextEditingController _occupationController;
  late TextEditingController _ageController;
  late TextEditingController _experienceLevelController;
  late TextEditingController _genderController;
  late AppUser user;

  double get bmiValue => _bmiValue;

  bool get isEditing => _isEditing;

  set isEditing(bool value) {
    _isEditing = value;
  }

  TextEditingController get occupationController => _occupationController;

  TextEditingController get ageController => _ageController;

  TextEditingController get experienceLevelController =>
      _experienceLevelController;

  TextEditingController get genderController => _genderController;

  void initializeControllers(AppUser user) {
    this.user = user;
    _occupationController = TextEditingController(text: user.info.occupation);
    _ageController = TextEditingController(text: user.info.age.toString());
    _experienceLevelController =
        TextEditingController(text: user.info.experienceLevel);
    _genderController = TextEditingController(text: user.info.gender);
    updateBMI(user);
    notifyListeners();
  }

  void updateBMI(AppUser user) {
    double bmi = calculateBMI(user.info.weight, user.info.height);
    _bmiValue = bmi;
  }

  double calculateBMI(double weight, double heightCm) {
    double heightM = heightCm / 100; // Convert height from cm to meters
    return weight / (heightM * heightM); // BMI formula
  }

  Color getShieldColor(double bmi) {
    if (bmi < 17.5) {
      return Colors.red; // Anorexia
    } else if (bmi >= 17.5 && bmi < 18.5) {
      return Colors.orange; // Underweight
    } else if (bmi >= 18.5 && bmi < 25) {
      return Colors.green; // Normal weight
    } else if (bmi >= 25 && bmi < 30) {
      return Colors.orange; // Overweight
    } else {
      return Colors.red; // Obesity
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _experienceLevelController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void addToList(List<String> list, String str) {
    list.add(str);
    notifyListeners();
  }

  void deleteFromList(List<String> list, String str) {
    list.remove(str);
    notifyListeners();
  }

  void changeHeight(double height) {
    user.info.height = height;
    updateBMI(user);
    notifyListeners();
  }

  void changeWeight(double weight) {
    user.info.weight = weight;
    updateBMI(user);
    notifyListeners();
  }

  void changeBodyFat(double bodyFat) {
    user.info.bodyFat = bodyFat;
    notifyListeners();
  }

  void changeNumTrainings(double num) {
    user.info.trainingsPerWeek = num;
    notifyListeners();
  }

  void changeDoingAerobic(bool value) {
    user.info.doingAerobic = value;
    notifyListeners();
  }

  Future<String?> getUserToken() async {
    try {
      // Get the current user
      auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

      // Ensure the user is not null
      if (currentUser == null) {
        throw Exception("No user is logged in");
      }

      // Get the token
      String? token = await currentUser.getIdToken();
      return "Bearer $token";
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  void handleEditClick(BuildContext context) async {
    if (this.isEditing) {
      user.info.occupation = occupationController.text;
      user.info.age = int.parse(ageController.text);
      user.info.gender = genderController.text;
      user.info.experienceLevel = experienceLevelController.text;
      this.isEditing = false;
    } else {
      this.isEditing = true;
      notifyListeners();
      return;
    }

    notifyListeners();
    String? token = await getUserToken();

    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
    if (progressProvider.achievements.lowestBodyFatPercent == 0) {
      progressProvider.achievements.lowestBodyFatPercent = 51;
    }
    if (user.info.bodyFat <
        progressProvider.achievements.lowestBodyFatPercent) {
      progressProvider.achievements.lowestBodyFatPercent = user.info.bodyFat;
      progressProvider.notifyListeners();
      if (token != null) {
        final achievementModel =
            AchievementAdapter.generalAchievementsToAchievementModel(
                progressProvider.achievements);
        await _statsApiService.updateAchievement(token, achievementModel);
      }
    }

    if (token != null) {
      // Convert profile picture (a file path) to base64 before sending
      PersonalInformationModel info = PersonalInformationModel(
        id: "",
        userID: "",
        firstName: "",
        lastName: "",
        profilePic: user.profilePicture,
        height: user.info.height,
        weight: user.info.weight,
        bodyFat: user.info.bodyFat,
        trainingsPerWeek: user.info.trainingsPerWeek.toInt(),
        doingAerobic: user.info.doingAerobic,
        age: user.info.age,
        gender: user.info.gender,
        occupation: user.info.occupation,
        experienceLevel: user.info.experienceLevel,
        certifications: user.info.certifications
            .map(
              (cert) => CertificationModel(
                title: cert.title,
                link: cert.link,
              ),
            )
            .toList(),
        languages: user.info.languages,
        specializations: user.info.specializations,
        socialAccounts: user.info.socialAccounts,
      );

      await _apiService.updateUser(token, info);
    }
  }

  void removeCert(int index) {
    user.info.certifications.removeAt(index);
    notifyListeners();
  }

  void showCert(Certification cert, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerPage(base64Pdf: cert.link),
      ),
    );
  }

  Future<String?> showUrlInputDialog(
      String urlType, BuildContext context) async {
    String url = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A2A35),
        title: Text(
          urlType == "PDF" ? 'Enter PDF URL' : 'Enter Social URL',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: urlType == "PDF"
                  ? 'https://example.com/document.pdf'
                  : 'https://instagram.com/username',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              url = value;
            },
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Color(0xFFEA6D13))),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Add', style: TextStyle(color: Color(0xFFEA6D13))),
            onPressed: () {
              Navigator.pop(context, url);
            },
          ),
        ],
      ),
    );
  }

  void addCert(BuildContext context) async {
    // Allow user to pick a PDF file or enter a URL
    String? choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => BottomSheetWidget(),
    );

    if (choice == 'file') {
      // Pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;

        // Prompt the user for a title
        String? title = await showTitleInputDialog(context, fileName);

        if (title != null && title.isNotEmpty) {
          // Convert the PDF file to Base64
          String base64Pdf = await Utility.fileToBase64(filePath);

          user.info.certifications.add(
            Certification(title: title, link: base64Pdf),
          );
          notifyListeners();
        }
      }
    } else if (choice == 'url') {
      // Enter a URL
      String? url = await showUrlInputDialog("PDF", context);
      if (url != null && url.isNotEmpty) {
        String? title = await showTitleInputDialog(context, 'Online PDF');
        if (title != null && title.isNotEmpty) {
          // Download the PDF from the URL and convert to Base64
          try {
            http.Response response = await http.get(Uri.parse(url));
            if (response.statusCode == 200) {
              // Convert the downloaded PDF bytes to Base64
              Uint8List pdfBytes = response.bodyBytes;
              String base64Pdf = base64Encode(pdfBytes);

              user.info.certifications.add(
                Certification(title: title, link: base64Pdf),
              );
              notifyListeners();
            } else {
              // Handle error if PDF can't be fetched
              print(
                  'Failed to download PDF. Status code: ${response.statusCode}');
            }
          } catch (e) {
            // Handle network errors
            print('Error downloading PDF: $e');
          }
        }
      }
    }
  }

  void updateCert(Certification cert, int index, BuildContext context) async {
    TextEditingController titleController =
        TextEditingController(text: cert.title);

    String? action = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Certification'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'update'),
              child: Text('Update'),
            ),
          ],
        );
      },
    );

    if (action == 'update') {
      cert.title = titleController.text;
      // Optionally allow changing the file or URL here if needed
      notifyListeners();
    }
  }

  Future<String?> showTitleInputDialog(
      BuildContext context, String defaultTitle) async {
    TextEditingController titleController =
        TextEditingController(text: defaultTitle);

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Title'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, titleController.text),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> showTextInputDialog(BuildContext context) async {
    String inputText = '';
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A2A35),
        title: Text('Enter Text', style: TextStyle(color: Colors.white)),
        content: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter text',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          onChanged: (value) {
            inputText = value;
          },
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Color(0xFFEA6D13))),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Add', style: TextStyle(color: Color(0xFFEA6D13))),
            onPressed: () {
              Navigator.pop(context, inputText);
            },
          ),
        ],
      ),
    );
  }

  Future<String?> showNetworkInputDialog(BuildContext context) async {
    // Define all possible networks.
    final List<String> networks = [
      'Facebook',
      'Instagram',
      'LinkedIn',
      'YouTube',
      'TikTok',
      'Telegram',
      'WhatsApp',
      'Snapchat',
      'X',
      'Phone',
      'Email',
    ];

    // Local variable for storing the selected network
    String? selectedNetwork;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0A2A35),
              title: const Text(
                'Select Social Network',
                style: TextStyle(color: Colors.white),
              ),
              content: Container(
                width: double.maxFinite,
                height: 200,
                child: ListView.builder(
                  itemCount: networks.length,
                  itemBuilder: (context, index) {
                    final network = networks[index];
                    return ListTile(
                      leading: Image.asset(
                        getSocialIcon(network),
                        width: 24,
                        height: 24,
                      ),
                      title: Text(
                        network,
                        style: const TextStyle(color: Colors.white),
                      ),
                      tileColor: (selectedNetwork == network)
                          ? Colors.blueGrey
                          : Colors.transparent,
                      onTap: () {
                        setState(() {
                          selectedNetwork = network;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFFEA6D13)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, selectedNetwork);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Color(0xFFEA6D13)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String getSocialIcon(String network) {
    switch (network.toLowerCase()) {
      case 'facebook':
        return 'assets/images/facebook.png';
      case 'instagram':
        return 'assets/images/instagram.png';
      case 'linkedin':
        return 'assets/images/linkedin.png';
      case 'youtube':
        return 'assets/images/youtube.png';
      case 'tiktok':
        return 'assets/images/tiktok.png';
      case 'telegram':
        return 'assets/images/telegram.png';
      case 'whatsapp':
        return 'assets/images/whatsapp.png';
      case 'snapchat':
        return 'assets/images/snapchat.png';
      case 'x':
        return 'assets/images/x.png';
      case 'phone':
        return 'assets/images/phone.png';
      case 'email':
        return 'assets/images/email.png';
      default:
        return 'assets/images/favicon.png'; // Default icon
    }
  }

  Future<String?> showUrlEditDialog(
      String network, String currentUrl, BuildContext context) async {
    TextEditingController urlController =
        TextEditingController(text: currentUrl);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A2A35),
        title: Text('Edit URL for $network',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: urlController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter URL',
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Color(0xFFEA6D13))),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Save', style: TextStyle(color: Color(0xFFEA6D13))),
            onPressed: () {
              Navigator.pop(context, urlController.text);
            },
          ),
        ],
      ),
    );
  }

  void changeProfilePicture(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      String base64Image = await Utility.fileToBase64(filePath);
      user.profilePicture = base64Image;
      notifyListeners();
    }
  }

  /// Replaces the original launchURL with a dialog that shows the URL
  /// and offers a "Copy" button.
  void launchURL(String url, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Info', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF0A2A35),
          content: SelectableText(
            url,
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Copy to clipboard
                Clipboard.setData(ClipboardData(text: url));
                // Optionally show a snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('URL copied to clipboard')),
                );
              },
              child: Text(
                'Copy',
                style: TextStyle(color: Color(0xFFEA6D13)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: Color(0xFFEA6D13)),
              ),
            ),
          ],
        );
      },
    );
  }

  void removeNetwork(String network) {
    if (user.info.socialAccounts.containsKey(network)) {
      user.info.socialAccounts.remove(network);
      notifyListeners();
    }
  }

  void updateNetwork(String network, String url, BuildContext context) async {
    String? newUrl = await showUrlEditDialog(network, url, context);
    if (newUrl != null) {
      user.info.socialAccounts[network] = newUrl;
    }
    notifyListeners();
  }

  void addNetwork(BuildContext context) async {
    String? network = await showNetworkInputDialog(context);
    if (network != null && network.isNotEmpty) {
      String? url = await showUrlInputDialog("Social", context);
      if (url != null && url.isNotEmpty) {
        user.info.socialAccounts[network] = url;
        notifyListeners();
      }
    }
  }

  IconData changeIcon(String network) {
    IconData iconData = Icons.access_alarm;
    switch (network.toLowerCase()) {
      case 'linkedin':
        iconData = Icons.work;
        break;
      case 'instagram':
        iconData = Icons.camera_alt;
        break;
      case 'facebook':
        iconData = Icons.facebook;
        break;
      case 'twitter':
        iconData = Icons.alternate_email;
        break;
      default:
        iconData = Icons.link;
        break;
    }
    return iconData;
  }
}
