import 'package:flutter/material.dart';
import 'package:lab3/pages/table_events.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils.dart';

class CalendarPage extends StatefulWidget {
  final Map<DateTime, List<Event>> events;

  const CalendarPage({Key? key, required this.events}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TableEvents(exams: widget.events),
          ),
        ],
      ),
    );
  }
}
