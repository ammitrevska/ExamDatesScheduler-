import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab3/exam.dart';
import 'package:lab3/pages/calendar_page.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final List<Exam> _exams = [];

@override
  void initState() {
    super.initState();
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "exam_channel",
          channelName: "Exam Notifications",
          channelDescription: "Notifications for upcoming exams",
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );

    _scheduleNotificationsForExistingExams();
  }


 void _scheduleNotificationsForExistingExams() {
    for (int i = 0; i < _exams.length; i++) {
      _scheduleExamNotification(_exams[i]);
    }
  }


void _scheduleExamNotification(Exam exam) {
  print("Scheduling notifications for existing exams");

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: _exams.indexOf(exam),
      channelKey: "exam_channel",
      title: "Upcoming Exam",
      body: "${exam.name} on ${DateFormat('yyyy-MM-dd').format(exam.date)}",
    ),
    // schedule: NotificationCalendar(
    //   day: exam.date.subtract(const Duration(days: 1)).day,
    //   month: exam.date.subtract(const Duration(days: 1)).month,
    //   year: exam.date.subtract(const Duration(days: 1)).year,
    //   hour: exam.date.subtract(const Duration(days: 1)).hour,
    //   minute: exam.date.subtract(const Duration(days: 1)).minute,
    //   second: 0,
    //   millisecond: 0,
    //   timeZone: "UTC", // Use local time zone
    // ),
  );
}


  void addAnExam() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String newExam = ' ';
      DateTime selectedDate = DateTime.now();
      TimeOfDay selectedTime = TimeOfDay.now();

      return AlertDialog(
        title: const Text('Add an exam'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  newExam = value;
                },
                decoration: const InputDecoration(labelText: 'Subject Name'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2055),
                      );
                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Pick Date'),
                  ),
                  const SizedBox(
                    width: 15,
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null && pickedTime != selectedTime) {
                        setState(
                          () {
                            selectedTime = pickedTime;
                          },
                        );
                      }
                    },
                    child: const Text('Pick Time'),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(
                () {
                  if (newExam.isNotEmpty) {
                    Exam exam = Exam(
                      name: newExam,
                      date: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      ),
                    );
                    _exams.add(exam);
                    _scheduleExamNotification(exam); // Schedule notification when the exam is added
                  }
                  Navigator.pop(context);
                },
              );
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}


  void _openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarWidget(exams: _exams),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text(
          '${user.email}',
          style: TextStyle(
            fontSize: 15,
            color: Colors.indigo[800],
          ),
        ),
        actions: [
          //Add button
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: Colors.indigo[800],
            ),
            onPressed: () {
              addAnExam();
            },
          ),

          // Calendar button
          IconButton(
            onPressed: () {
              _openCalendar();
            },
            icon: Icon(
              Icons.calendar_month_rounded,
              color: Colors.indigo[800],
            ),
          ),

          //logout button
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.indigo[800],
            ),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 2,
        children: List.generate(
          _exams.length,
          (index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _exams[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(_exams[index].date)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Time: ${DateFormat.Hm().format(_exams[index].date)}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
