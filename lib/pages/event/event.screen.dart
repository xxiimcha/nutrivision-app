import 'package:flutter/material.dart';
import 'package:sjq/pages/event/_event_list.dart';
import 'package:sjq/services/services.dart';
import 'package:sjq/themes/themes.dart';
import 'package:table_calendar/table_calendar.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  EventService eventService = EventService();
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  void _onDateSelected(DateTime selected, DateTime focused) {
    setState(() {
      selectedDay = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorLightBlue,
        title: const Text("PROGRAM SCHEDULE", style: headingS),
        centerTitle: true,
        elevation: 3,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorLightBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020),
                  lastDay: DateTime.utc(2040),
                  focusedDay: selectedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  onDaySelected: _onDateSelected,
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: headingM.copyWith(color: Colors.red),
                    formatButtonVisible: false,
                  ),
                  calendarStyle: const CalendarStyle(
                    weekendTextStyle: TextStyle(color: Colors.red),
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 67, 100),
                      shape: BoxShape.circle,
                    ),
                  ),
                  rowHeight: 40,
                  availableGestures: AvailableGestures.all,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: EventListViewer(date: selectedDay.toIso8601String()), // Pass the selected date
              ),
            ],
          ),
        ),
      ),
    );
  }
}
