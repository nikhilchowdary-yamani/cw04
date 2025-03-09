import 'package:flutter/material.dart';
import '../models/plan.dart';

class PlanListItem extends StatelessWidget {
  final Plan plan;
  final Function(String) onDelete;
  final Function(String) onToggleStatus;
  final Function(String) onEdit;

  const PlanListItem({
    Key? key,
    required this.plan,
    required this.onDelete,
    required this.onToggleStatus,
    required this.onEdit,
  }) : super(key: key);

  @override
  // In lib/widgets/plan_list_item.dart
@override
Widget build(BuildContext context) {
  // Color based on status
  final Color statusColor = plan.status == PlanStatus.completed
      ? Colors.green.shade100
      : Colors.blue.shade100;
  
  // Priority indicator
  IconData priorityIcon;
  Color priorityColor;
  String priorityText = plan.priority.toString().split('.').last.toUpperCase();

  switch (plan.priority) {
    case PlanPriority.high:
      priorityIcon = Icons.priority_high;
      priorityColor = Colors.red;
      break;
    case PlanPriority.medium:
      priorityIcon = Icons.drag_handle;
      priorityColor = Colors.orange;
      break;
    case PlanPriority.low:
      priorityIcon = Icons.arrow_downward;
      priorityColor = Colors.green;
      break;
  }

  return GestureDetector(
    // Double tap to delete
    onDoubleTap: () => onDelete(plan.id),
    
    // Long press to edit
    onLongPress: () => onEdit(plan.id),
    
    child: Dismissible(
      key: Key(plan.id),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.check, color: Colors.white),
      ),
      onDismissed: (direction) => onToggleStatus(plan.id),
      child: Card(
        color: statusColor,
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            // Priority banner at the top of card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(priorityIcon, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'PRIORITY: $priorityText',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            ListTile(
              leading: CircleAvatar(
                backgroundColor: priorityColor,
                child: Icon(priorityIcon, color: Colors.white),
              ),
              title: Text(
                plan.name,
                style: TextStyle(
                  decoration: plan.status == PlanStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.description),
                  Text(
                    'Date: ${plan.date.day}/${plan.date.month}/${plan.date.year}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              trailing: plan.status == PlanStatus.completed
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.pending, color: Colors.orange),
            ),
          ],
        ),
      ),
    ),
  );
}
}