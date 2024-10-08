class Event {
  int id;
  final String title;
  final String location;
  final String time;
  final String date;

  Event({
    this.id = 0,
    this.title = '',
    this.location = '',
    this.time = '',
    this.date = '',
  });

  // Convert Event model to Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'time': time,
      'date': date,
    };
  }

  // Convert Json to Event model
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      time: json['time'] ?? '',
      date: json['date'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Event: $title, Location: $location, Date: $date';
  }
}
