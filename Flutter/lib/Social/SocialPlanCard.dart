import 'package:IOFit/Social/SocialPlan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'social_personal_widget.dart';
import '../Plans/PlanList/plan_data.dart';
import '../User/user_db.dart';
import 'SocialProvider.dart';

class SocialPlanCard extends StatelessWidget {
  final SocialPlan sPlan;

  const SocialPlanCard({
    Key? key,
    required this.sPlan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SocialProvider>(context, listen: false);

    return Card(
      margin: EdgeInsets.all(8.0),
      color: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade700),
      ),
      child: InkWell(
        onTap: () => provider.clickOnPlan(context, sPlan.plan),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
            children: [
              // Leading image
              sPlan.plan.url.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  sPlan.plan.url,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, color: Colors.grey);
                  },
                ),
              )
                  : Icon(Icons.fitness_center, color: Colors.grey, size: 60),
              SizedBox(width: 12.0),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      sPlan.plan.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    // Subtitle
                    Text(
                      sPlan.plan.subTitle,
                      style: TextStyle(color: Colors.black),
                    ),
                    // Action buttons
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: Colors.blue),
                          onPressed: () => provider.likePlan(sPlan.plan),
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down, color: Colors.red),
                          onPressed: () => provider.dislikePlan(sPlan.plan),
                        ),
                        Text(
                          'Rating: ${sPlan.plan.rating}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Trailing icon
              IconButton(
                icon: Icon(Icons.person, color: Colors.black),
                onPressed: () {
                  // Navigate to the plan's creator profile in read-only mode
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SocialPersonalWidget(
                        user: sPlan.info, // Make sure 'aitana' is defined
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
