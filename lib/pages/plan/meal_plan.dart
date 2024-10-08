import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:sjq/themes/themes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';  // Firebase Storage

class PlanScreen extends StatefulWidget {
  final String patientId;
  final String weekStartDate;

  const PlanScreen({
    Key? key,
    required this.patientId,
    required this.weekStartDate,
  }) : super(key: key);

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  Map<String, dynamic> mealPlan = {};
  bool isLoading = true;
  DateTime currentWeekStart = DateTime.now();
  int? expandedPanelIndex;
  File? _selectedImage; // For storing the selected image
  bool isUploading = false; // To show upload progress

  @override
  void initState() {
    super.initState();
    currentWeekStart = _getMondayOfCurrentWeek(DateTime.now());
    _loadMealPlan();
  }

  // Method to get the Monday of the current week
  DateTime _getMondayOfCurrentWeek(DateTime date) {
    final int daysToSubtract = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: daysToSubtract));
  }

  // Format date to 'yyyy-MM-dd'
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Navigate to the previous week
  void _previousWeek() {
    setState(() {
      currentWeekStart = currentWeekStart.subtract(const Duration(days: 7));
      _loadMealPlan();
    });
  }

  // Navigate to the next week
  void _nextWeek() {
    setState(() {
      currentWeekStart = currentWeekStart.add(const Duration(days: 7));
      _loadMealPlan();
    });
  }

  Future<void> _loadMealPlan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        print('Error: User ID not found in SharedPreferences.');
        return;
      }

      String weekStart = _formatDate(currentWeekStart);

      // Construct the full URL
      String url = 'http://localhost:5000/api/mealplans/${widget.patientId}/$weekStart';

      print('Request URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      print('HTTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic>) {
          setState(() {
            mealPlan = responseData;
            isLoading = false;
          });
        } else {
          setState(() {
            mealPlan = {};
            isLoading = false;
          });
        }
      } else {
        print('Failed to load meal plan: ${response.reasonPhrase}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading meal plan: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Pick image from camera and upload to Firebase for a specific day and meal type
  Future<void> _takePhoto(String day, String mealType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      await _uploadPhotoToFirebase(day, mealType);  // Upload to Firebase
    }
  }

  // Pick image from gallery and upload to Firebase for a specific day and meal type
  Future<void> _uploadPhoto(String day, String mealType) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });

      await _uploadPhotoToFirebase(day, mealType);  // Upload to Firebase
    }
  }

 // Upload the selected image to Firebase Storage and save the URL to the database
  Future<void> _uploadPhotoToFirebase(String day, String mealType) async {
    if (_selectedImage == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      // Create a unique file path in Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('meal_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the image
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);

      // Wait until the upload is complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print('Image uploaded. URL: $downloadUrl');

      // Send the download URL to your backend to save in the database
      await _saveImageUrlToDatabase(day, mealType, downloadUrl);

    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  // Method to save the image URL to the backend database
  Future<void> _saveImageUrlToDatabase(String day, String mealType, String imageUrl) async {
    try {
      // Construct the request body with the image URL and other relevant data
      Map<String, dynamic> requestBody = {
        'patientId': widget.patientId,
        'weekStartDate': widget.weekStartDate,
        'day': day,  // e.g., "Monday"
        'mealType': mealType,  // e.g., "breakfast"
        'imageUrl': imageUrl,  // Firebase image URL
      };

      // Make the HTTP POST request to your backend API
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/mealplans/saveImageUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Image URL saved successfully.');
      } else {
        print('Failed to save image URL: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error saving image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime weekEnd = currentWeekStart.add(const Duration(days: 6));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorLightBlue,
        title: const Text("Meal Plan", style: headingS),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousWeek,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Text(
                  '${_formatDate(currentWeekStart)} to ${_formatDate(weekEnd)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                ElevatedButton(
                  onPressed: _nextWeek,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildAccordion(),
                  ),
          ),
          if (isUploading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  // Build Accordion for each day
  Widget _buildAccordion() {
    List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    return ExpansionPanelList.radio(
      initialOpenPanelValue: expandedPanelIndex,
      children: daysOfWeek.asMap().entries.map((entry) {
        int index = entry.key;
        String day = entry.value;
        Map<String, dynamic>? meals = mealPlan[day]; // Access meals for the day

        return ExpansionPanelRadio(
          value: index,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                day,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          },
          // Pass both 'day' and 'meals' to the _buildMealPlanForDay method
          body: meals != null
              ? _buildMealPlanForDay(day, meals) // Now passes both arguments
              : const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('No meal plan for this day', style: TextStyle(color: Colors.grey)),
                ),
        );
      }).toList(),
    );
  }

  // Build meal plan cards for a day (breakfast, lunch, dinner)
  Widget _buildMealPlanForDay(String day, Map<String, dynamic> meals) {
    return Column(
      children: ['breakfast', 'lunch', 'dinner'].map((mealType) {
        if (meals.containsKey(mealType) && meals[mealType] != null && meals[mealType]['approved'] == true) {
          return Column(
            children: [
              _buildMealCard(mealType, meals[mealType]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _takePhoto(day, mealType);  // Pass day and mealType to take photo
                    },
                    child: const Text("Take Photo"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _uploadPhoto(day, mealType);  // Pass day and mealType to upload photo
                    },
                    child: const Text("Upload Photo"),
                  ),
                ],
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(_selectedImage!, width: 100, height: 100),
                ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$mealType: No approved meal',
              style: const TextStyle(color: Colors.grey),
            ),
          );
        }
      }).toList(),
    );
  }

  // Build a single meal card
  Widget _buildMealCard(String mealType, Map<String, dynamic> mealData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  mealType.toUpperCase(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.help_outline),
                  tooltip: 'Show Ingredients',
                  onPressed: () {
                    _showIngredientsModal(context, mealType, mealData['ingredients']);
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: mealData['approved'] == true ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    mealData['approved'] == true ? 'DONE' : 'IN PROGRESS',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildMealRow("Main dish", mealData['mainDish']),
            _buildMealRow("Drinks", mealData['drinks']),
            _buildMealRow("Vitamins", mealData['vitamins']),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Show a modal with the ingredients
  void _showIngredientsModal(BuildContext context, String mealType, List<dynamic>? ingredients) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$mealType Ingredients'),
          content: ingredients != null && ingredients.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ingredients.map((ingredient) {
                    return ListTile(
                      leading: const Icon(Icons.check),
                      title: Text(ingredient.toString()),
                    );
                  }).toList(),
                )
              : const Text('No ingredients available'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Display a single row for a meal detail
  Widget _buildMealRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value ?? 'N/A')),
      ],
    );
  }

}
