import 'dart:collection';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

Map<DateTime, List<Event>> generateEvents(List<Map<String, dynamic>> exams) {
  return Map.fromIterable(exams,
    key: (exam) => DateTime.parse(exam['date']),
    value: (exam) => [Event(exam['name'])],
  );
}

final _kEventSource = generateEvents([]);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
