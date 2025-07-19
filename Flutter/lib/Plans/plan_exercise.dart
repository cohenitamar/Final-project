class PlanExercise {
  final String name;
  final String imagePath;
  final String category;
  int rep;
  int sets;
  int weight;
  bool checked;

  PlanExercise({
    required this.name,
    required this.imagePath,
    required this.category,
    required this.rep,
    required this.sets,
    required this.weight,
    required this.checked
  });
}
