import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/plan.dart';

class PlanCalendar extends StatefulWidget {
  final List<Plan> plans;
  final Function(DateTime) onDaySelected;

  const PlanCalendar({
    Key? key,
    required this.plans,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  _PlanCalendarState createState() => _PlanCalendarState();
}

class _PlanCalendarState extends State<PlanCalendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  List<Plan> _getPlansForDay(DateTime day) {
    return widget.plans.where((plan) {
      return plan.date.year == day.year &&
          plan.date.month == day.month &&
          plan.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2021, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDaySelected(selectedDay);
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          calendarStyle: CalendarStyle(
            markersMaxCount: 3,
            markerDecoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: _getPlansForDay,
        ),
        const SizedBox(height: 8),
        if (_getPlansForDay(_selectedDay).isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plans on ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ..._getPlansForDay(_selectedDay).map((plan) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 8),
                          const SizedBox(width: 8),
                          Text(plan.name),
                        ],
                      ),
                    )),
              ],
            ),
          ),
      ],
    );
  }
}