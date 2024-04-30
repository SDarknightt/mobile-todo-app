class Task {
  final String id;
  final String status;
  final String title;
  final String description;
  final String creationDate;
  final String responsibleId;
  final bool disabled;

  Task({
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.responsibleId,
    required this.disabled,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      status: json['status'],
      title: json['title'],
      description: json['description'],
      creationDate: json['creationDate'],
      responsibleId: json['responsibleId'],
      disabled: json['disabled'],
    );
  }
}