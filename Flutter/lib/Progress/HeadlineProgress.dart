import 'package:flutter/material.dart';

class HeadlineProgress extends StatefulWidget {
  final String title;


  const HeadlineProgress({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<HeadlineProgress> createState() => _HeadlineProgressState();
}

class _HeadlineProgressState extends State<HeadlineProgress> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:13,top:15,right: 13,bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calories Burned Display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )],
          ),],
      ),
    );}
}

