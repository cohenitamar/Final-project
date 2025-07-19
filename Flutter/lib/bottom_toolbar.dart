import 'package:flutter/material.dart';

class BottomToolbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomToolbar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  final Color backgroundColor = const Color(0xFF293544);
  final Color selectedItemColor = const Color(0xFFEA6D13);
  final Color unselectedItemColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: backgroundColor,
      child: BottomNavigationBar(
        backgroundColor: backgroundColor,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
