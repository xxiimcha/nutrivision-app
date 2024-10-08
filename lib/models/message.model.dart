class Message {
  final String sender;
  final String receiver;
  final String text;
  final DateTime timestamp;
  String? senderName; // Add a nullable field for the sender's name

  Message({
    required this.sender,
    required this.receiver,
    required this.text,
    required this.timestamp,
    this.senderName, // Add the senderName in the constructor
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'],
      receiver: json['receiver'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      senderName: json['senderName'], // Make sure this matches the field you expect
    );
  }

  // Convert Message instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'receiver': receiver,
      'text': text,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to ISO string format
      'senderName': senderName, // Convert DateTime to ISO string format
    };
  }
}
