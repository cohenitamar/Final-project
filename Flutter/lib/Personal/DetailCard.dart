import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget valueWidget;

  const DetailCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.valueWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      color: Colors.grey.shade400,
      fontSize: 16.0,
    );

    return Card(
      color: const Color(0xFF0A2A35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade700),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFEA6D13),
          size: 30.0,
        ),
        title: Text(
          title,
          style: labelStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: valueWidget,
      ),
    );
  }
}
