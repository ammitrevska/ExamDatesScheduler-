import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab3/exam.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  final List<Exam> exams;

  const CalendarWidget({super.key, required this.exams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text(
          'Exams',
          style: TextStyle(
            color: Colors.indigo[800],
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.indigo[800],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: _getCalendarDataSource(),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell) {
            _handleDateTap(context, details.date!);
          }
        },
      ),
    );
  }

  _DataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    for (var exam in exams) {
      appointments.add(Appointment(
        startTime: exam.date,
        endTime: exam.date.add(const Duration(hours: 2)),
        subject: exam.name,
      ));
    }

    return _DataSource(appointments);
  }

  void _handleDateTap(BuildContext context, DateTime selectedDate) {
    List<Exam> selectedExams = exams
        .where((exam) =>
            exam.date.year == selectedDate.year &&
            exam.date.month == selectedDate.month &&
            exam.date.day == selectedDate.day)
        .toList();

    if (selectedExams.isNotEmpty) {
      _showExamsDialog(context, selectedDate, selectedExams);
    }
  }

  void _showExamsDialog(
      BuildContext context, DateTime selectedDate, List<Exam> exams) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Exams on ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height *
                  0.5, // Set your desired max height
            ),
            child: SingleChildScrollView(
              child: Column(
                children: exams
                    .map((exam) => Text(
                        '${exam.name} - ${exam.date.hour}:${exam.date.minute}'))
                    .toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}
