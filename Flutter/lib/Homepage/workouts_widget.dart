
import 'package:flutter/material.dart';
import '../Exercise/exercise_widget.dart';
import '../SearchExercise/exercise.dart';
import 'local_db_homepage.dart';

class WorkoutsListWidget extends StatefulWidget {
  final Exercise exc;


  const WorkoutsListWidget({
    Key? key,
    required this.exc,

  }) : super(key: key);

  @override
  State<WorkoutsListWidget> createState() => _WorkoutsListWidgetState();
}

class _WorkoutsListWidgetState extends State<WorkoutsListWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseWidget(exercise: widget.exc,
            ),
          ));
          // Define what happens when the widget is tapped
        },
        child: Container(
          width: 200.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white, // Replace with desired background color
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.asset(
                      widget.exc.imagePath,
                      width: 300.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0), // Spacing between image and text
                // Text Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle Text
                      Text(
                        widget.exc.category,
                        style: const TextStyle(
                          fontFamily: 'Readex Pro', // Ensure this font is available
                          fontSize: 12.0,
                          color: Colors.black, // Adjust color as needed
                        ),
                      ),
                      // Title Text
                      Text(
                        widget.exc.name,
                        style: const TextStyle(
                          fontFamily: 'Readex Pro', // Ensure this font is available
                          fontSize: 16.0,
                          color: Colors.black, // Adjust color as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
