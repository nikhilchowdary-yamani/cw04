import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/plan.dart';
import '../widgets/plan_list_item.dart';
import '../widgets/plan_calendar.dart';
import '../widgets/plan_drag_target.dart';
import '../widgets/plan_draggable.dart';
import '../widgets/priority_stats.dart';


class PlanManagerScreen extends StatefulWidget {
  const PlanManagerScreen({Key? key}) : super(key: key);

  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  final List<Plan> _plans = [];
  final uuid = Uuid();
  PlanPriority? _priorityFilter;

  List<Plan> _getFilteredPlans() {
  if (_priorityFilter == null) {
    return _plans;
  }
  
  return _plans.where((plan) => plan.priority == _priorityFilter).toList();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: const Text('Adoption & Travel Planner'),
  actions: [
    PopupMenuButton<PlanPriority?>(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filter by priority',
      onSelected: (PlanPriority? value) {
        setState(() {
          _priorityFilter = value;
        });
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: null,
          child: Text('All Priorities'),
        ),
        PopupMenuItem(
          value: PlanPriority.high,
          child: Row(
            children: [
              Icon(Icons.priority_high, color: Colors.red),
              const SizedBox(width: 8),
              const Text('High Priority'),
            ],
          ),
        ),
        PopupMenuItem(
          value: PlanPriority.medium,
          child: Row(
            children: [
              Icon(Icons.drag_handle, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Medium Priority'),
            ],
          ),
        ),
        PopupMenuItem(
          value: PlanPriority.low,
          child: Row(
            children: [
              Icon(Icons.arrow_downward, color: Colors.green),
              const SizedBox(width: 8),
              const Text('Low Priority'),
            ],
          ),
        ),
      ],
    ),
  ],
),
body: Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlanCalendar(
              plans: _plans,
              onDaySelected: (date) {
              },
            ),
          ),
        ),
        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Drag to create:',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const PlanDraggable(),
    ],
  ),
),
PlanDragTarget(
  date: DateTime.now(),
  onAccept: (name, description, date, priority) {
    _showAddPlanDialogWithPrefilledData(name, description, date, priority);
    PriorityStats(plans: _plans);
  },
),
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
  final filteredPlans = _getFilteredPlans();
  
  if (filteredPlans.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No plans found.'),
          if (_priorityFilter != null)
            TextButton.icon(
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Clear Filter'),
              onPressed: () {
                setState(() {
                  _priorityFilter = null;
                });
              },
            ),
        ],
      ),
    );
  }
  
  filteredPlans.sort((a, b) {
    int priorityComparison = b.priority.index.compareTo(a.priority.index);
    if (priorityComparison != 0) {
      return priorityComparison;
    }
    
    return a.status.index.compareTo(b.status.index);
  });
  
  return ListView.builder(
    itemCount: filteredPlans.length,
    itemBuilder: (context, index) {
      return PlanListItem(
        plan: filteredPlans[index],
        onDelete: _deletePlan,
        onToggleStatus: _togglePlanStatus,
        onEdit: _showEditPlanDialog,
      );
    },
  );
}
  void _showAddPlanDialogWithPrefilledData(
  String name,
  String description,
  DateTime date,
  PlanPriority priority,
) {
  final nameController = TextEditingController(text: name);
  final descriptionController = TextEditingController(text: description);
  DateTime selectedDate = date;
  PlanPriority selectedPriority = priority;

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
          ],
        ),
      ),
      actions: [
      ],
    ),
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
    border: OutlineInputBorder(),
  ),
  items: PlanPriority.values.map((priority) {
    final name = priority.toString().split('.').last;
    IconData icon;
    Color color;
    
    switch (priority) {
      case PlanPriority.high:
        icon = Icons.priority_high;
        color = Colors.red;
        break;
      case PlanPriority.medium:
        icon = Icons.drag_handle;
        color = Colors.orange;
        break;
      case PlanPriority.low:
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
    }
    
    return DropdownMenuItem(
      value: priority,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Text(
            name.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
                border: OutlineInputBorder(),
              ),
              items: PlanPriority.values.map((priority) {
                final name = priority.toString().split('.').last;
                IconData icon;
                Color color;
                
                switch (priority) {
                  case PlanPriority.high:
                    icon = Icons.priority_high;
                    color = Colors.red;
                    break;
                  case PlanPriority.medium:
                    icon = Icons.drag_handle;
                    color = Colors.orange;
                    break;
                  case PlanPriority.low:
                    icon = Icons.arrow_downward;
                    color = Colors.green;
                    break;
                }
                
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(icon, color: color),
                      const SizedBox(width: 10),
                      Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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