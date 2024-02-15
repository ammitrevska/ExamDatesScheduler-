import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget{
  final Map<DateTime, List<Map<String, dynamic>>> events;

  const CalendarPage({super.key, required this.events});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>{
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {

    //back button

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calendar Page'),
        ),
        body: TableCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
          firstDay: DateTime(2000),
          lastDay: DateTime(2050),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            // Update `_focusedDay` when the page changes.
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            // Load events for the specified day
            final exams = widget.events[day] ?? [];
            return exams.map((exam) => exam['name'].toString()).toList();
          },
        ),
      ),
    );
  }
}