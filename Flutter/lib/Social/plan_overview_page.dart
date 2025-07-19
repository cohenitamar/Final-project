import 'package:IOFit/Progress/ProgressProvider.dart';
import 'package:IOFit/Social/SocialProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Plans/ExerciseListItem.dart';
import '../Plans/PlanList/plan_data.dart';
import '../Plans/PlanProvider.dart'; // Import your PlanProvider
import '../Plans/plan_exercise.dart'; // Import your PlanTile

class PlanOverviewPage extends StatelessWidget {
  final PlanTile plan;

  const PlanOverviewPage({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socialProvider = Provider.of<SocialProvider>(context, listen: false);
    // Access the plan exercises
    final exercises = plan.exercises..sort((a, b) => a.name.compareTo(b.name));

    // Define custom colors and text styles
    const Color primaryColor = Color(0xFF062029);
    const Color accentColor = Color(0xFFF29C62);
    const Color textColor = Colors.white;

    TextStyle headlineStyle = const TextStyle(
      fontFamily: 'Outfit',
      color: textColor,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final TextStyle labelMediumStyle = TextStyle(
      fontFamily: 'Readex Pro',
      color: textColor.withOpacity(0.7),
      fontSize: 14.0,
    );

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30.0),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.title, style: headlineStyle),
                Text('Created on ${plan.cDate}', style: labelMediumStyle),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Bar (we can remove this if not needed)
          // Exercise List
          Expanded(
            child: exercises.isEmpty
                ? Center(
                    child: Text(
                      'No exercises found.',
                      style: labelMediumStyle,
                    ),
                  )
                : ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      PlanExercise exercise = exercises[index];
                      return ExerciseListItem(
                        planId: 0,
                        exercise: null,
                        planExercise: exercise,
                        isEditing: false,
                        isExpanded: false,
                        social: true,
                      );
                    },
                  ),
          ),
          // Add to My Plans Button
          SafeArea(
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: primaryColor,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade700),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: accentColor,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add to My Plans'),
                  onPressed: () {
                    socialProvider.addPlanToMyPlans(context, plan);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Plan added to your plans.')),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
