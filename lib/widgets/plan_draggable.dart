import 'package:flutter/material.dart';
import '../models/plan.dart';

class PlanDraggable extends StatefulWidget {
  const PlanDraggable({Key? key}) : super(key: key);

  @override
  _PlanDraggableState createState() => _PlanDraggableState();
}

class _PlanDraggableState extends State<PlanDraggable> {
  PlanPriority _priority = PlanPriority.medium;

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    
    switch (_priority) {
      case PlanPriority.high:
        color = Colors.red;
        icon = Icons.priority_high;
        break;
      case PlanPriority.medium:
        color = Colors.orange;
        icon = Icons.drag_handle;
        break;
      case PlanPriority.low:
        color = Colors.green;
        icon = Icons.arrow_downward;
        break;
    }

    return Column(
      children: [
        DropdownButton<PlanPriority>(
          value: _priority,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: (PlanPriority? newValue) {
            if (newValue != null) {
              setState(() {
                _priority = newValue;
              });
            }
          },
          items: PlanPriority.values.map<DropdownMenuItem<PlanPriority>>((PlanPriority value) {
            String name = value.toString().split('.').last.toUpperCase();
            IconData dropIcon;
            Color dropColor;
            
            switch (value) {
              case PlanPriority.high:
                dropIcon = Icons.priority_high;
                dropColor = Colors.red;
                break;
              case PlanPriority.medium:
                dropIcon = Icons.drag_handle;
                dropColor = Colors.orange;
                break;
              case PlanPriority.low:
                dropIcon = Icons.arrow_downward;
                dropColor = Colors.green;
                break;
            }
            
            return DropdownMenuItem<PlanPriority>(
              value: value,
              child: Row(
                children: [
                  Icon(dropIcon, color: dropColor, size: 16),
                  const SizedBox(width: 8),
                  Text(name),
                ],
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 8),
        
        LongPressDraggable<Map<String, dynamic>>(
          data: {
            'name': 'New Plan',
            'description': 'Drag to add a new plan',
            'priority': _priority,
          },
          feedback: Container(
            width: 150,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const Text(
                    'New Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 18),
                  const SizedBox(width: 4),
                  const Text(
                    'New Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}