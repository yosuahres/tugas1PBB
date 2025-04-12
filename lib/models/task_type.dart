enum TaskType { today, planned, urgent }

extension TaskTypeExtension on TaskType {
  String get name {
    switch (this) {
      case TaskType.today:
        return 'Today';
      case TaskType.planned:
        return 'Planned';
      case TaskType.urgent:
        return 'Urgent';
      default:
        return '';
    }
  }

  static TaskType fromString(String value) {
    switch (value) {
      case 'today':
        return TaskType.today;
      case 'planned':
        return TaskType.planned;
      case 'urgent':
        return TaskType.urgent;
      default:
        throw ArgumentError('Invalid TaskType string: $value');
    }
  }

}