import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:http/http.dart' as http; // For sending HTTP requests
import 'package:provider/provider.dart'; // For using Provider
import 'package:flutter/services.dart';
import 'dart:convert';

import 'SearchExercise/ai_predictions.dart';
import 'SearchExercise/exercise.dart';
import 'SearchExercise/search_exercise_provider.dart'; // <-- Make sure this is your correct path

typedef ExerciseItemBuilder = Widget Function(
  BuildContext context,
  Exercise exercise,
);

class ExerciseListScreen extends StatefulWidget {
  final String title;
  final ExerciseItemBuilder itemBuilder;
  final bool isSearch;

  const ExerciseListScreen({
    Key? key,
    required this.title,
    required this.itemBuilder,
    required this.isSearch,
  }) : super(key: key);

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  String choiceChipsValue = 'All';
  List<Exercise> exercises = [];
  List<Exercise> filteredExercises = [];
  TextEditingController searchController = TextEditingController();

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Load exercises from the provider
    final searchExerciseProvider =
        Provider.of<SearchExerciseProvider>(context, listen: false);
    exercises = searchExerciseProvider.eList;
    filterWorkouts();

    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    filterWorkouts();
  }

  void filterWorkouts() {
    setState(() {
      final query = searchController.text.toLowerCase();

      if (choiceChipsValue == 'All') {
        filteredExercises = exercises.where((exercise) {
          return exercise.name.toLowerCase().contains(query);
        }).toList();
      } else {
        filteredExercises = exercises.where((exercise) {
          return exercise.category == choiceChipsValue &&
              exercise.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF1A1A2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        actions: widget.isSearch
            ? [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: () {
                    _pickImageAndPredict(context);
                  },
                ),
              ]
            : null,
        surfaceTintColor: Colors.transparent,
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: !widget.isSearch
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search for exercises',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white12,
              ),
            ),
          ),
          // Choice Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: _buildChoiceChips(),
            ),
          ),
          // Exercise List
          Expanded(
            child: filteredExercises.isEmpty
                ? const Center(
                    child: Text(
                      'No exercises found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = filteredExercises[index];
                      return widget.itemBuilder(context, exercise);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChoiceChips() {
    List<String> categories = [
      'All',
      'Abdominals',
      'Abductors',
      'Biceps',
      'Calves',
      'Chest',
      'Forearms',
      'Glutes',
      'Hamstrings',
      'Lats',
      'Lower Back',
      'Middle Back',
      'Neck',
      'Quadriceps',
      'Shoulders',
      'Traps',
      'Triceps',
    ];

    return categories.map((category) {
      final bool isSelected = choiceChipsValue == category;
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(
          label: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          selected: isSelected,
          selectedColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          onSelected: (selected) {
            setState(() {
              choiceChipsValue = category;
              filterWorkouts();
            });
          },
        ),
      );
    }).toList();
  }

// Function to pick an image and send it to the server
  Future<void> _pickImageAndPredict(BuildContext context) async {
    try {
      final searchExerciseProvider =
          Provider.of<SearchExerciseProvider>(context, listen: false);
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Send the image to the server and get the result
        String result = await _sendImageToServer(File(image.path));

        final exercises = searchExerciseProvider.eList
            .where((exercise) => exercise.machine == result)
            .toList();

        // Now open the PredictionScreen with the resulting string
        // as the predicted machine name.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PredictionScreen(
              predictedMachineName: result,
              // Provide the exercises list here
              exercises: exercises, // Replace with your actual List<Exercise>
            ),
          ),
        );
      } else {
        // User canceled the picker
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      _showErrorDialog(context, 'Failed to pick image.');
    }
  }

  // Function to send the image to the Python server
  Future<String> _sendImageToServer(File imageFile) async {
    String url =
        'http://10.0.2.2:5001/predict'; // Replace with your server's IP address
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['prediction'];
      } else {
        return 'Error: Server responded with status code ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('Error sending image to server: $e');
      return 'Error: $e';
    }
  }

  // Function to display an error dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
