class Exercise {
  final String name;
  final String imagePath;
  final String category;
  final String fullSizeImagePath;
  final String instructions;
  final String muscles;
  final String machine;

  Exercise({
    required this.name,
    required this.imagePath,
    required this.category,
    required this.fullSizeImagePath,
    required this.instructions,
    required this.muscles,
    required this.machine,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imagePath': imagePath,
      'category': category,
      'fullSizeImagePath': fullSizeImagePath,
      'instructions': instructions,
      'muscles': muscles,
      'machine': machine,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] ?? '',
      imagePath: map['imagePath'] ?? '',
      category: map['category'] ?? '',
      fullSizeImagePath: map['fullSizeImagePath'] ?? '',
      instructions: map['instructions'] ?? '',
      muscles: map['muscles'] ?? '',
      machine: map['machine'] ?? '',
    );
  }
}
