import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/important_day.dart';
import '../services/storage_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final storage = StorageService();
  List<ImportantDay> days = [];

  @override
  void initState() {
    super.initState();
    loadDays();
  }

  void loadDays() async {
    final data = await storage.getImportantDays();
    setState(() => days = data);
  }

  List<ImportantDay> eventsForDay(DateTime date) {
    return days
        .where(
          (e) =>
              e.date.year == date.year &&
              e.date.month == date.month &&
              e.date.day == date.day,
        )
        .toList();
  }

  void addDay(DateTime date) async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thêm ngày quan trọng'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              days.add(ImportantDay(date: date, title: controller.text));
              await storage.saveImportantDays(days);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch tình yêu')),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime(2000),
        lastDay: DateTime(2100),
        eventLoader: eventsForDay,
        onDaySelected: (selectedDay, _) => addDay(selectedDay),
      ),
    );
  }
}
