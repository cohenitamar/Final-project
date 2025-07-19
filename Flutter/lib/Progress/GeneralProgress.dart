import 'package:flutter/material.dart';

class GeneralProgress extends StatefulWidget {
  final String title;
  final String initialValue;
  final IconData icon;
  final Color color;

  const GeneralProgress({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  State<GeneralProgress> createState() => _GeneralProgressState();
}

class _GeneralProgressState extends State<GeneralProgress> {
  late String currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E2D3B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.color,
              size: 30.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.initialValue,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

