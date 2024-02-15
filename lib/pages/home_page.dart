import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab3/pages/calendar_page.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final _exams = <Map<String, dynamic>>[];
  final _events = <DateTime, List<Map<String, dynamic>>>{};

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
                        DateTime? picedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2055),
                        );
                        if (picedDate != null && picedDate != selectedDate) {
                          setState(() {
                            selectedDate = picedDate;
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
                      _exams.add({
                        'name': newExam,
                        'date': selectedDate,
                        'time': selectedTime,
                      });

                      _events[selectedDate] ??= [];
                      _events[selectedDate]!.add({
                        'name': newExam,
                        'time': selectedTime,
                      });
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

  void openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarPage(
          events: _events,
        ),
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

          //calendar button
          IconButton(
            onPressed: () {
              openCalendar();
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
                      _exams[index]['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(_exams[index]['date'])}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Time: ${_exams[index]['time'].format(context)}',
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
