enum PlanStatus { pending, completed }
enum PlanPriority { low, medium, high }

class Plan {
  String id;
  String name;
  String description;
  DateTime date;
  PlanStatus status;
  PlanPriority priority;

  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.status = PlanStatus.pending,
    this.priority = PlanPriority.medium,
  });
}