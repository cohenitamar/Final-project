import 'package:IOFit/Homepage/CalendarProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'homepage_provider.dart';
import 'local_db_homepage.dart';


class CalendarWidget extends StatefulWidget {


  CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: true);
    return TableCalendar(
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: calendarProvider.focusedDay.value,
      selectedDayPredicate: (day) {
        return isSameDay(calendarProvider.selectedDay, day);
      },
      calendarFormat: calendarProvider.calendarFormat,
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week',
      },
      onDaySelected: (selectedDay, focusedDay) {
        calendarProvider.handleDaySelected(selectedDay, focusedDay);
      },
      onPageChanged: (focusedDay) {
        calendarProvider.changeFocusVal(focusedDay);
        print(focusedDay);
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        selectedTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
            fontSize: 24.0),
        defaultTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 16.0),
        todayTextStyle: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16.0),
        weekendTextStyle: const TextStyle(
            color: Colors.white, fontSize: 16.0),
        outsideTextStyle: const TextStyle(
            color: Colors.grey, fontSize: 16.0),
      ),
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(color: Colors.white),
        formatButtonVisible: false,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.white,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.white,
        ),
        headerPadding: EdgeInsets.symmetric(vertical: 8.0),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white),
      ),
      eventLoader: (day) {
        // Checks if the day is a marked date.
        if (calendarProvider.historyList.any((markedDate) => isSameDay(markedDate, day))) {
          return [1]; // Placeholder for marking dates
        }
        return [];
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          // Check if the day is in the list of dates to mark with green checkmark
          if (calendarProvider.historyList.any(
                  (markedDate) => isSameDay(markedDate, day))) {
            return Positioned(
              bottom: -4,
              child: Icon(
                Icons.check, // Displaying the checkmark icon
                color: Colors.green, // Green color for the checkmark
                size: 20, // Size of the checkmark icon
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
