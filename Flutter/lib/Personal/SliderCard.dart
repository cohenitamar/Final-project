import 'package:flutter/material.dart';

class SliderCard extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final double min;
  final double max;
  final int divisions;
  final Function(double)? onChanged;

  const SliderCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
    required this.divisions,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );

    return Card(
      color: const Color(0xFF0A2A35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade700),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title: ${value.toStringAsFixed(0)} $unit', style: labelStyle),
            Slider(
              activeColor: const Color(0xFFEA6D13),
              inactiveColor: Colors.blueAccent,
              min: min,
              max: max,
              value: value == 0 ? min : value,
              label: value.toStringAsFixed(0),
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
