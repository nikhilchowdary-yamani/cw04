import 'package:flutter/material.dart';
import '../models/plan.dart';

class PlanDraggable extends StatelessWidget {
  const PlanDraggable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<Map<String, dynamic>>(
      data: {
        'name': 'New Plan',
        'description': 'Drag to add a new plan',
        'priority': PlanPriority.medium,
      },
      feedback: Container(
        width: 150,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'New Plan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'New Plan',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'New Plan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}