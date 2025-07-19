import 'package:flutter/material.dart';

class CategoryChoiceChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onSelected;

  const CategoryChoiceChips({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: categories.map((category) {
          final bool isSelected = selectedCategory == category;

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
                if (selected) {
                  onSelected(category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
