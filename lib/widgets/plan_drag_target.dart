import 'package:flutter/material.dart';
import '../models/plan.dart';

class PlanDragTarget extends StatelessWidget {
  final Function(String name, String description, DateTime date, PlanPriority priority) onAccept;
  final DateTime date;

  const PlanDragTarget({
    Key? key,
    required this.onAccept,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<Map<String, dynamic>>(
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: candidateData.isNotEmpty ? Colors.green : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            color: candidateData.isNotEmpty
                ? Colors.green.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              'Drop here to add plan for ${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                color: candidateData.isNotEmpty ? Colors.green : Colors.grey,
              ),
            ),
          ),
        );
      },
      onAccept: (data) {
        onAccept(
          data['name'] as String,
          data['description'] as String,
          date,
          data['priority'] as PlanPriority,
        );
      },
    );
  }
}