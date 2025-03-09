import 'package:flutter/material.dart';
import '../models/plan.dart';

class PriorityStats extends StatelessWidget {
  final List<Plan> plans;

  const PriorityStats({
    Key? key,
    required this.plans,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int highCount = 0;
    int mediumCount = 0;
    int lowCount = 0;
    
    for (final plan in plans) {
      switch (plan.priority) {
        case PlanPriority.high:
          highCount++;
          break;
        case PlanPriority.medium:
          mediumCount++;
          break;
        case PlanPriority.low:
          lowCount++;
          break;
      }
    }
    
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPriorityStatItem(
                  Icons.priority_high,
                  Colors.red,
                  'High',
                  highCount,
                ),
                _buildPriorityStatItem(
                  Icons.drag_handle,
                  Colors.orange,
                  'Medium',
                  mediumCount,
                ),
                _buildPriorityStatItem(
                  Icons.arrow_downward,
                  Colors.green,
                  'Low',
                  lowCount,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPriorityStatItem(
    IconData icon,
    Color color,
    String label,
    int count,
  ) {
    return Column(
      children: [
        Icon(icon, color: color),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}