
class Exercise {
  final String name;
  final int sets;
  final int reps;
  final int weight;


  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.weight,

  });
}

class Workout {
  final String id;
  final String name;
  final DateTime date;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.name,
    required this.date,
    required this.exercises,
  });
}
// lib/data/workout_history.dart


final List<Workout> workoutHistory = [
  Workout(
    id: '1',
    name: 'Full Body Workout',
    date: DateTime(2024, 4, 20),
    exercises: [
      Exercise(name: 'Push Ups', sets: 3, reps: 12,weight: 10),
      Exercise(name: 'Squats', sets: 4, reps: 15,weight: 10),
      Exercise(name: 'Pull Ups', sets: 3, reps: 10,weight: 10),
    ],
  ),
  Workout(
    id: '2',
    name: 'Upper Body Strength',
    date: DateTime(2024, 4, 18),
    exercises: [
      Exercise(name: 'Bench Press', sets: 4, reps: 8,weight: 10),
      Exercise(name: 'Bicep Curls', sets: 3, reps: 12,weight: 10),
      Exercise(name: 'Tricep Dips', sets: 3, reps: 10,weight: 10),
    ],
  ),
  // Add more workout entries as needed
];
