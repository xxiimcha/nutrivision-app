class WeeklyImprovement {
  final String id;
  final String patientId;
  final int weekNumber;
  final int improvement;
  final DateTime createdAt;

  WeeklyImprovement({
    required this.id,
    required this.patientId,
    required this.weekNumber,
    required this.improvement,
    required this.createdAt,
  });

  // Factory method to create a WeeklyImprovement object from JSON
  factory WeeklyImprovement.fromJson(Map<String, dynamic> json) {
    return WeeklyImprovement(
      id: json['_id'] as String,
      patientId: json['patientId'] as String,
      weekNumber: json['weekNumber'] as int,
      improvement: json['improvement'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Method to convert a WeeklyImprovement object into JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'weekNumber': weekNumber,
      'improvement': improvement,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
