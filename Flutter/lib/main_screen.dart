import 'package:IOFit/Social/social_widget.dart';
import 'package:flutter/material.dart';
import 'Settings/settings_widget.dart';
import 'Progress/progress_widget.dart';
import 'Personal/personal_widget.dart';
import 'Homepage/homepage.dart';
import 'SearchExercise/search_exercise_widget.dart';
import 'Plans/PlanList/plan_list_widget.dart';
import 'bottom_toolbar.dart';
import 'Login/login_widget.dart';
import 'Register/register_widget.dart';
import 'User/user_db.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    //LoginWidget(),
    //RegisterWidget(),
    WorkWidget(),
    PlanListWidget(),
    SearchExerciseWidget(),
    PersonalWidget(isEditable:  true),
    SocialWidget(),
    ProgressWidget(),
    SettingsWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomToolbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}