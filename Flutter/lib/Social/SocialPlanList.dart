import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CategoryChoiceChips.dart';
import '../Plans/PlanList/plan_data.dart';
import 'SocialPlan.dart';
import 'SocialProvider.dart';
import 'SocialPlanCard.dart';

class SocialPlanList extends StatelessWidget {
  const SocialPlanList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socialProvider = Provider.of<SocialProvider>(context);

    // If still loading, show a loading indicator
    if (socialProvider.isLoadingPlans) {
      return const Center(child: CircularProgressIndicator());
    }

    // Categories List
    final List<String> categories = [
      'All',
      'Abdominals',
      'Abductors',
      'Biceps',
      'Calves',
      'Chest',
      'Forearms',
      'Glutes',
      'Hamstrings',
      'Lats',
      'Lower Back',
      'Middle Back',
      'Neck',
      'Quadriceps',
      'Shoulders',
      'Traps',
      'Triceps',
    ];

    // Grab the social plans and sort them
    List<SocialPlan> plans = socialProvider.socialPlans;
    plans.sort((a, b) => b.plan.rating.compareTo(a.plan.rating));

    return Column(
      children: [
        // Categories should be visible all the time
        CategoryChoiceChips(
          categories: categories,
          selectedCategory: socialProvider.selectedCategory,
          onSelected: (category) {
            socialProvider.setSelectedCategory(category);
          },
        ),

        // Use Expanded for the list, so the categories remain on top
        Expanded(
          child: plans.isEmpty
              ? const Center(
            child: Text(
              'There are no shared plans.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              SocialPlan plan = plans[index];
              return SocialPlanCard(sPlan: plan);
            },
          ),
        ),
      ],
    );
  }
}
