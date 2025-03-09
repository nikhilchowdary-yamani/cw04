import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/plan.dart';
import '../widgets/plan_list_item.dart';
import '../widgets/plan_calendar.dart';

class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({Key? key}) : super(key: key);

  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  final List<Plan> _plans = [];
  final uuid = Uuid();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Adoption & Travel Planner'),
    ),
    body: Column(
      children: [
        // Calendar
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlanCalendar(
              plans: _plans,
              onDaySelected: (date) {
                // Filter plans by selected date or show plans for selected date
                // You could also show a dialog to add a plan on this date
              },
            ),
          ),
        ),
        
        // Plan list
        Expanded(
          child: _buildPlanList(),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showAddPlanDialog,
      tooltip: 'Create Plan',
      child: const Icon(Icons.add),
    ),
  );
}
  Widget _buildPlanList() {
  if (_plans.isEmpty) {
    return const Center(
      child: Text('No plans yet. Tap + to add a new plan.'),
    );
  }
  
  // Sort plans by priority (high to low)
  _plans.sort((a, b) => b.priority.index.compareTo(a.priority.index));
  
  return ListView.builder(
    itemCount: _plans.length,
    itemBuilder: (context, index) {
      return PlanListItem(
        plan: _plans[index],
        onDelete: _deletePlan,
        onToggleStatus: _togglePlanStatus,
        onEdit: _showEditPlanDialog,
      );
    },
  );
}
void _showEditPlanDialog(String id) {
  final planIndex = _plans.indexWhere((plan) => plan.id == id);
  if (planIndex == -1) return;

  final plan = _plans[planIndex];
  final nameController = TextEditingController(text: plan.name);
  final descriptionController = TextEditingController(text: plan.description);
  DateTime selectedDate = plan.date;
  PlanPriority selectedPriority = plan.priority;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Edit Plan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Plan Name',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Date: '),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PlanPriority>(
              value: selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
              items: PlanPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedPriority = value;
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Status: '),
                Switch(
                  value: plan.status == PlanStatus.completed,
                  onChanged: (value) {
                    setState(() {
                      plan.status = value ? PlanStatus.completed : PlanStatus.pending;
                    });
                  },
                ),
                Text(
                  plan.status == PlanStatus.completed ? 'Completed' : 'Pending',
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.trim().isNotEmpty) {
              _updatePlan(
                id,
                nameController.text,
                descriptionController.text,
                selectedDate,
                selectedPriority,
                plan.status,
              );
              Navigator.of(ctx).pop();
            }
          },
          child: const Text('Update'),
        ),
      ],
    ),
  );
}

void _updatePlan(
  String id,
  String name,
  String description,
  DateTime date,
  PlanPriority priority,
  PlanStatus status,
) {
  setState(() {
    final planIndex = _plans.indexWhere((plan) => plan.id == id);
    if (planIndex != -1) {
      _plans[planIndex] = Plan(
        id: id,
        name: name,
        description: description,
        date: date,
        priority: priority,
        status: status,
      );
    }
  });
}
void _deletePlan(String id) {
  setState(() {
    _plans.removeWhere((plan) => plan.id == id);
  });
}

void _togglePlanStatus(String id) {
  setState(() {
    final planIndex = _plans.indexWhere((plan) => plan.id == id);
    if (planIndex != -1) {
      final currentStatus = _plans[planIndex].status;
      _plans[planIndex].status = currentStatus == PlanStatus.pending
          ? PlanStatus.completed
          : PlanStatus.pending;
    }
  });
}
  void _showAddPlanDialog() {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  PlanPriority selectedPriority = PlanPriority.medium;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Create New Plan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Plan Name',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Date: '),
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PlanPriority>(
              value: selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
              items: PlanPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedPriority = value;
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (nameController.text.trim().isNotEmpty) {
              _addPlan(
                nameController.text,
                descriptionController.text,
                selectedDate,
                selectedPriority,
              );
              Navigator.of(ctx).pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    ),
  );
}

void _addPlan(String name, String description, DateTime date, PlanPriority priority) {
  setState(() {
    _plans.add(
      Plan(
        id: uuid.v4(),
        name: name,
        description: description,
        date: date,
        priority: priority,
      ),
    );
  });
}
}