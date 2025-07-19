import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HistoryPageProvider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key,
  required this.clicked,
  });
  final String clicked;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    print("build");
    // Sort workouts by date descending
    final historyProvider =
        Provider.of<HistoryPageProvider>(context, listen: true);
    historyProvider.handleClick(widget.clicked);

    return ListView.builder(
      shrinkWrap: true,
      // Allows ListView to take only the needed space
      physics: const NeverScrollableScrollPhysics(),
      // Disables ListView's own scrolling
      itemCount: historyProvider.filteredHistory.length,
      itemBuilder: (context, index) {
        final workout = historyProvider.filteredHistory[index];
        return Card(
          color: const Color(0xFF1E2D3B),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            leading: const Icon(Icons.fitness_center, color: Colors.teal),
            title: Text(
              workout.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Date: " + workout.executionDate + "\nDuration: " + workout.executionTime,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            children: workout.exercises.map((exercise) {
              return Column(
                children: [
                  ListTile(
                    leading: exercise.checked
                        ? Icon(Icons.thumb_up_sharp, color: Colors.green)
                        : Icon(Icons.thumb_down, color: Colors.red),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      'Sets: ${exercise.sets} | Reps: ${exercise.rep} | Weight: ${exercise.weight} kg',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    indent: 70,
                    color: Colors.white70,
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
