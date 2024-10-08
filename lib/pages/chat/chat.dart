import 'package:flutter/material.dart';
import 'package:sjq/services/chat/chat.service.dart'; // Import your chat service
import 'package:sjq/models/message.model.dart'; // Import your message model

class ChatScreen extends StatefulWidget {
  final String sender;
  final String loggedInUserId;
  final String senderName; // Add senderName parameter

  const ChatScreen({
    Key? key, 
    required this.sender, 
    required this.loggedInUserId, 
    required this.senderName // Ensure senderName is required
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatService chatService = ChatService();
  Future<List<Message>> messages = Future.value([]);
  TextEditingController messageController = TextEditingController(); // Controller for the message input

  @override
  void initState() {
    super.initState();
    _loadChatMessages(); // Load chat messages between the sender and the logged-in user
  }

  // Fetch messages between the sender and logged-in user (both ways)
  Future<void> _loadChatMessages() async {
    setState(() {
      messages = chatService.getMessagesBetweenUsers(widget.loggedInUserId, widget.sender);
    });
  }

  // Function to send a message
  Future<void> _sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return; // Do not send if the message is empty
    }

    try {
      // Call the sendMessage method in ChatService
      await chatService.sendMessage(widget.loggedInUserId, widget.sender, messageController.text);

      // Clear the input field
      messageController.clear();

      // Reload chat messages after sending
      _loadChatMessages();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white), // Placeholder for user avatar
            ),
            SizedBox(width: 10),
            Text(widget.senderName), // Display the sender's name passed from the previous screen
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Message>>(
              future: messages, // Fetch the chat messages
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading messages'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages found'));
                } else {
                  final chatMessages = snapshot.data!;
                  return ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final message = chatMessages[index];
                      bool isSentByLoggedInUser = message.sender == widget.loggedInUserId;

                      return Align(
                        alignment: isSentByLoggedInUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSentByLoggedInUser ? Colors.greenAccent : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: isSentByLoggedInUser ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: _sendMessage, // Call the send message function when the send button is pressed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
