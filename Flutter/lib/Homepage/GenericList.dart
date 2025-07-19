import 'dart:math'; // For min() function
import 'package:flutter/material.dart';

class GenericList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const GenericList({
    Key? key,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the item count so it doesn’t exceed 10
    final itemCount = min(items.length, 10);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: itemBuilder(item),
        );
      },
    );
  }
}
