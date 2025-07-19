import 'package:IOFit/Homepage/CalendarWidget.dart';
import 'package:IOFit/Homepage/homepage_provider.dart';
import 'package:IOFit/Homepage/suggested_widget.dart';
import 'package:IOFit/Plans/PlanList/plan_data.dart';
import 'package:IOFit/Progress/HistoryPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../file_handler.dart';
import 'GenericList.dart';
import 'workouts_widget.dart';
import '../User/user_db.dart';
import '../SearchExercise/exercise.dart';
import 'local_db_homepage.dart';
import '../Plans/PlanProvider.dart';
import '../bottom_toolbar.dart';
import '../CategoryChoiceChips.dart';

class WorkWidget extends StatefulWidget {
  const WorkWidget({Key? key}) : super(key: key);

  @override
  State<WorkWidget> createState() => _WorkWidgetState();
}

class _WorkWidgetState extends State<WorkWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider =
    Provider.of<HistoryPageProvider>(context, listen: true);
    final homeProvider = Provider.of<HomepageProvider>(context, listen: true);
    final planProvider = Provider.of<PlanProvider>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF062029),
        appBar: AppBar(
          backgroundColor: const Color(0xFF062029),
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, ${homeProvider.user.firstName} ${homeProvider.user.lastName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                homeProvider.getGreeting(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              child: Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: Utility.getImageProvider(
                    homeProvider.user.profilePicture,
                  ),
                ),
              ),
            ),
          ],
          toolbarHeight: 72.0,
          elevation: 0.0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF062029),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Calendar Widget
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: CalendarWidget(),
                ),

                /// Categories
                const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 15.0, 0.0, 0.0),
                  child: Text(
                    'Recently viewed exercises',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),

                /// Category Choice Chips
                CategoryChoiceChips(
                  categories: homeProvider.categories,
                  selectedCategory: homeProvider.choiceChipsValue,
                  onSelected: (selectedCategory) {
                    homeProvider.filterWorkouts(selectedCategory, context);
                  },
                ),

                /// Workouts List
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 200.0,
                    child: homeProvider.filteredWorkouts.isEmpty
                        ? const Center(
                      child: Text(
                        'No recently viewed workouts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                        : GenericList<Exercise>(
                      items: homeProvider.filteredWorkouts,
                      itemBuilder: (exercise) =>
                          WorkoutsListWidget(exc: exercise),
                    ),
                  ),
                ),

                /// Suggested
                const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 0.0),
                  child: Text(
                    'Suggested',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: planProvider.suggestedPlans.length,
                    itemBuilder: (context, index) {
                      final suggestion = planProvider.suggestedPlans[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SuggestedWidget(p: suggestion),
                      );
                    },
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
