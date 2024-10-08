import 'package:flutter/material.dart';
import 'package:sjq/services/chat/chat.service.dart'; // Import your chat service
import 'package:sjq/models/message.model.dart'; // Import your message model
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import 'chat.dart'; // Import the Chat page for navigation

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatService chatService = ChatService(); // Instance of ChatService to handle API or data fetching
  
  // Initialize messages with an empty Future so it can be updated later
  Future<List<Message>> messages = Future.value([]); 
  String? loggedInUserId; // Variable to store logged-in user ID
  TextEditingController searchController = TextEditingController(); // Search controller
  String searchQuery = ''; // Search query to filter the contact list

  @override
  void initState() {
    super.initState();
    _loadLoggedInUserId(); // Load the logged-in user's ID when the widget is initialized
  }

  // Method to load logged-in user ID from SharedPreferences
  Future<void> _loadLoggedInUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance
    setState(() {
      loggedInUserId = prefs.getString('userId'); // Fetch the stored userId
      if (loggedInUserId != null) {
        // Fetch messages where sender or receiver is the logged-in user
        messages = chatService.getMessagesForUser(loggedInUserId!); 
        print('User ID found in SharedPreferences: $loggedInUserId');
      }
    });
  }

  // Group messages by sender
  Map<String, List<Message>> groupMessagesBySender(List<Message> messages) {
    Map<String, List<Message>> groupedMessages = {};
    
    for (var message in messages) {
      if (!groupedMessages.containsKey(message.sender)) {
        groupedMessages[message.sender] = [];
      }
      groupedMessages[message.sender]!.add(message);
    }
    
    return groupedMessages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TELEMEDICINE", style: TextStyle(color: Colors.white)), // Title of the page
        centerTitle: true, // Center the title
        backgroundColor: Colors.blue, // Set background color of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding around the content
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase(); // Update search query when typing
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Contacts',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Message>>(
                future: messages, // Future that fetches messages
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator while messages are being fetched
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show error message if there's an error loading the messages
                    return const Center(child: Text('Error loading messages'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Show message if no messages are available
                    return const Center(child: Text('No messages available'));
                  } else {
                    final messageList = snapshot.data!; // Retrieve the list of messages

                    // Group messages by sender
                    final groupedMessages = groupMessagesBySender(messageList);

                    // Display senders as contacts with search filtering
                    final filteredSenders = groupedMessages.keys.where((sender) {
                      return sender.toLowerCase().contains(searchQuery); // Filter based on search query
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredSenders.length, // Number of filtered senders
                      itemBuilder: (context, index) {
                        final sender = filteredSenders[index]; // Get the sender at the current index
                        final lastMessage = groupedMessages[sender]!.last; // Get the last message from the sender

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child: Icon(Icons.person, color: Colors.white), // Placeholder for user avatar
                              ),
                              title: Text(
                                lastMessage.senderName ?? sender, // Display the sender's name if available
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Text('Start conversation'), // Display the subtitle as "Start conversation"
                              onTap: () {
                                // Pass the sender's name to the chat screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      sender: sender, // Pass the sender ID to ChatScreen
                                      loggedInUserId: loggedInUserId!, // Pass the logged-in user ID
                                      senderName: lastMessage.senderName ?? sender, // Pass the sender name, fallback to sender ID if not available
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
