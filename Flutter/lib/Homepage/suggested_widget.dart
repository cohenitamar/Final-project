import 'package:IOFit/Plans/PlanStart/plan_start.dart';
import 'package:IOFit/Social/plan_overview_page.dart';
import 'package:flutter/material.dart';
import '../Plans/PlanList/plan_data.dart';
import 'local_db_homepage.dart';

class SuggestedWidget extends StatefulWidget {
  final PlanTile p;


  const SuggestedWidget({
    Key? key,
    required this.p,
  }) : super(key: key);

  @override
  State<SuggestedWidget> createState() => _SuggestedWidgetState();
}

class _SuggestedWidgetState extends State<SuggestedWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanOverviewPage(plan: widget.p),
            ),
          );
          // Define any action you want to trigger when the widget is tapped
        },
        child: Container(
          width: 200.0,
          height: 100.0,
          decoration: BoxDecoration(
            color: Colors.white, // Replace with desired background color
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.asset(
                      widget.p.url,
                      width: 300.0,
                      height: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0), // Spacing between image and text
                // Text Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 4.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Text
                      Text(
                        widget.p.title,
                        style: const TextStyle(
                          fontFamily: 'Readex Pro', // Ensure this font is available
                          fontSize: 16.0,
                          color: Colors.black, // Adjust color as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
