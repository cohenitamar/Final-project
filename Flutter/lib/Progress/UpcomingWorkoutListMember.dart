import 'package:flutter/material.dart';

class UpcomingWorkoutListMember extends StatefulWidget {
  final String title;


  const UpcomingWorkoutListMember({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<UpcomingWorkoutListMember> createState() => _UpcomingWorkoutListMemberState();
}

class _UpcomingWorkoutListMemberState extends State<UpcomingWorkoutListMember> {

  void initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
    // Find the index of the first space
    int spaceIndex = widget.title.indexOf(' ');

    // Split into two parts
    String part1 = spaceIndex != -1 ? widget.title.substring(0, spaceIndex) : widget.title;
    String part2 = spaceIndex != -1 ? widget.title.substring(spaceIndex + 1) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        children: [
          // Left column (fixed width) with ellipsis for part1
          SizedBox(
            width: 265,
            child: Text(
              part1,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis, // Ellipsis for overflow
            ),
          ),
          // Right column (fixed width) with ellipsis for part2
          SizedBox(
            width: 100,
            child: Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.tealAccent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    part2,
                    overflow: TextOverflow.ellipsis, // Ellipsis for overflow
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}


class UpcomingWorkoutList{
  final String day;
  final List <String> workoutNameList;
  UpcomingWorkoutList({required this.day,required this.workoutNameList});

  // Convert the class instance to a JSON-like Map
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'workoutNameList': workoutNameList,
    };
  }

  // Create a class instance from a JSON-like Map
  factory UpcomingWorkoutList.fromJson(Map<String, dynamic> json) {
    return UpcomingWorkoutList(
      day: json['day'],
      workoutNameList: List<String>.from(json['workoutNameList']),
    );
  }


}
