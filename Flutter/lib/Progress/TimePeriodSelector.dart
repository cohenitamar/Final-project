

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePeriodSelector extends StatefulWidget {

  const TimePeriodSelector({super.key,required this.clicked,required this.clickedChanged, required this.timePeriods});
  final String clicked;
  final Function(String) clickedChanged;
  final List<String> timePeriods;
  @override
  _TimePeriodSelectorState createState() => _TimePeriodSelectorState();

}
class _TimePeriodSelectorState extends State<TimePeriodSelector> {
  String selectedPeriod = ""; // Default selected period


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    List<String> timePeriods = widget.timePeriods;
    String clicked = widget.clicked;

    selectedPeriod = clicked;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: timePeriods.map((period) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: selectedPeriod == period ? Colors.white : Colors.black, backgroundColor: selectedPeriod == period ? Colors.deepOrange[400] : Colors.grey[300],
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
                ),
              ),
              onPressed: () {
                  selectedPeriod = period; // Update selected period
                  widget.clickedChanged(period);
              },
              child: Text(period),
            ),
          );
        }).toList(),
      ),
    );
  }
}