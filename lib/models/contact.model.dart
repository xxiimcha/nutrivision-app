// Only name for now.
class Contact {
  int id;
  final String name;
  Contact({this.id = 0, this.name = ''});

  // Convert Contact model to Json
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  // Convert Json to Contact model
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  @override
  String toString() {
    return 'Name: $name';
  }
}
