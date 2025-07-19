
import 'package:flutter/material.dart';
import 'workout.dart';

class WorkoutDetail extends StatelessWidget {
  final Workout workout;

  const WorkoutDetail({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${workout.date.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Exercises',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...workout.exercises.map((exercise) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(Icons.fitness_center, color: Colors.blue),
                title: Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text('Sets: ${exercise.sets} | Reps: ${exercise.reps}'),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
