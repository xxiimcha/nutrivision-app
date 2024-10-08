import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjq/models/client.model.dart';
import 'package:sjq/services/user/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjq/themes/themes.dart';
import 'patients_details.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  UserService userService = UserService();
  TextEditingController addressController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController patientNameController = TextEditingController();
  TextEditingController patientDobController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController dateOfWeighingController = TextEditingController();

  String selectedSex = 'Male'; // Default selection
  String weightForAge = 'Normal';
  String heightForAge = 'Normal';
  String weightForHeight = 'Normal';
  String nutritionStatus = 'Normal';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Client> patients = []; // To store the list of patients
  bool showForm = false; // To toggle between the form and the list of patients

  @override
  void initState() {
    super.initState();
    _loadPatients(); // Load patient records when the screen is initialized
  }

  Future<void> _loadPatients() async {
    String? userId = await getUserId();
    if (userId != null) {
      List<Client> records = await userService.getPatientsByUserId(userId);
      setState(() {
        patients = records;
      });
    }
  }

  void _clearFormFields() {
    addressController.clear();
    motherNameController.clear();
    patientNameController.clear();
    patientDobController.clear();
    heightController.clear();
    weightController.clear();
    dateOfWeighingController.clear();
    setState(() {
      weightForAge = 'Normal';
      heightForAge = 'Normal';
      weightForHeight = 'Normal';
      nutritionStatus = 'Normal';
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _calculateStatuses(); // Recalculate statuses after the date is picked
      });
    }
  }

  void _calculateStatuses() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;
    int ageInMonths = _calculateAgeInMonths();

    if (weight <= 0 || height <= 0 || ageInMonths == 0 || ageInMonths > 59) {
      setState(() {
        nutritionStatus = 'Unknown'; // Set Unknown if values are invalid
      });
      return;
    }

    // Calculate Weight-for-Age
    if (ageInMonths <= 1) {
      if (weight < 2.5) {
        weightForAge = 'Underweight';
      } else if (weight >= 2.5 && weight <= 4.5) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    } else if (ageInMonths <= 3) {
      if (weight < 4.5) {
        weightForAge = 'Underweight';
      } else if (weight >= 4.5 && weight <= 6.5) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    } else if (ageInMonths <= 6) {
      if (weight < 6) {
        weightForAge = 'Underweight';
      } else if (weight >= 6 && weight <= 8) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    } else if (ageInMonths <= 12) {
      if (weight < 7.5) {
        weightForAge = 'Underweight';
      } else if (weight >= 7.5 && weight <= 10.5) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    } else if (ageInMonths <= 24) {
      if (weight < 9) {
        weightForAge = 'Underweight';
      } else if (weight >= 9 && weight <= 12.5) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    } else if (ageInMonths <= 36) {
      if (weight < 11) {
        weightForAge = 'Underweight';
      } else if (weight >= 11 && weight <= 15) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    } else if (ageInMonths <= 48) {
      if (weight < 12.5) {
        weightForAge = 'Underweight';
      } else if (weight >= 12.5 && weight <= 18) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    } else if (ageInMonths <= 59) {
      if (weight < 13) {
        weightForAge = 'Underweight';
      } else if (weight >= 13 && weight <= 20) {
        weightForAge = 'Normal';
      } else {
        weightForAge = 'Overweight';
      }
    }

    // Calculate Weight-for-Height (simple ratio as an example)
    double weightToHeightRatio = weight / height;
    if (weightToHeightRatio < 0.15) {
      weightForHeight = 'Wasted';
    } else if (weightToHeightRatio >= 0.15 && weightToHeightRatio <= 0.20) {
      weightForHeight = 'Normal';
    } else {
      weightForHeight = 'Overweight';
    }

    // Final Nutrition Status: Malnourished, Normal, or Obese
    if (weightForAge == 'Underweight' || weightForHeight == 'Wasted') {
      nutritionStatus = 'Malnourished';
    } else if (weightForAge == 'Overweight' || weightForHeight == 'Overweight') {
      nutritionStatus = 'Obese';
    } else {
      nutritionStatus = 'Normal';
    }

    // Update UI
    setState(() {
      weightForAge = weightForAge;
      heightForAge = heightForAge;
      weightForHeight = weightForHeight;
      nutritionStatus = nutritionStatus;
    });
  }

  int _calculateAgeInMonths() {
    if (patientDobController.text.isEmpty) return 0;
    try {
      DateTime dob = DateTime.parse(patientDobController.text);
      DateTime now = DateTime.now();
      int ageInMonths = (now.year - dob.year) * 12 + now.month - dob.month;

      if (ageInMonths > 59) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Age exceeds 59 months.')),
        );
        return 0;
      }
      return ageInMonths;
    } catch (e) {
      return 0;
    }
  }

  Future<void> saveButtonPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      int ageInMonths = _calculateAgeInMonths();
      if (ageInMonths == 0 || ageInMonths > 59) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Age exceeds 59 months. Please enter a valid date of birth.')),
        );
        return;
      }

      String address = addressController.text;
      String motherName = motherNameController.text;
      String patientName = patientNameController.text;
      String patientDob = patientDobController.text;
      String patientHeight = heightController.text;
      String patientSex = selectedSex;
      String patientWeight = weightController.text;
      String actualDate = dateOfWeighingController.text;
      String? userId = await getUserId(); // Get the current user's ID

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User ID not found')),
        );
        return;
      }

      // Show the preview dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Preview Details'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Mother/Caregiver: $motherName'),
                  Text('Child\'s Name: $patientName'),
                  Text('Date of Birth: $patientDob'),
                  Text('Gender: $patientSex'),
                  Text('Height: $patientHeight cm'),
                  Text('Weight: $patientWeight kg'),
                  Text('Address: $address'),
                  Text('Nutrition Status: $nutritionStatus'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog without saving
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  // Confirm and submit data
                  Client newClient = Client(
                    guardian: motherName,
                    address: address,
                    name: patientName,
                    dob: patientDob,
                    gender: patientSex,
                    height: patientHeight,
                    weight: patientWeight,
                    dateOfWeighing: actualDate,
                    weightForAge: weightForAge,
                    heightForAge: heightForAge,
                    weightForHeight: weightForHeight,
                    nutritionStatus: nutritionStatus,
                    ageInMonths: ageInMonths,
                    userId: userId, // Pass the userId to the client object
                  );

                  await userService.createEntry(newClient);
                  _clearFormFields();
                  _loadPatients(); // Reload the patient list after saving a new entry
                  setState(() {
                    showForm = false; // Show the patient list after saving
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Client saved successfully!')),
                  );

                  Navigator.of(context).pop(); // Close the dialog after saving
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Retrieve the stored userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorLightBlue,
        title: const Text("Patient Records", style: headingS),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: patients.isEmpty
            ? showForm
                ? _buildForm() // Show form if there are no records
                : Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showForm = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Button color (blue)
                        foregroundColor: Colors.white, // Text color (white)
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        elevation: 5, // Adds shadow to give a raised effect
                      ),
                      child: const Text(
                        "Add New Entry",
                        style: TextStyle(
                          fontSize: 18, // Larger text size
                          fontWeight: FontWeight.bold, // Bold text for emphasis
                        ),
                      ),
                    ),
                  )
            : showForm
                ? _buildForm() // Show form if user clicked "Add New Entry"
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient List",
                        style: headingS,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: patients.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0), // Adds vertical spacing between items
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to the details screen when tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientDetailsScreen(patient: patients[index]),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3, // Adds a subtle shadow for depth
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15), // Rounded corners for the card
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0), // Adds padding inside the card
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patients[index].name ?? 'Unknown Name',
                                        style: const TextStyle(
                                          fontSize: 18, // Increased font size for better readability
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue, // Blue text for the patient name
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showForm = true;
                            });
                          },
                          child: const Text("Add New Entry"),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Please fill out this form with the required details.", style: headingS),
            const SizedBox(height: 15),

            // Address Field
            TextFormField(
              controller: addressController,
              textCapitalization: TextCapitalization.words, // Capitalize first letter of each word
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the address';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: paragraphS,
                hintText: 'ADDRESS',
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Mother/Caregiver Name Field
            TextFormField(
              controller: motherNameController,
              textCapitalization: TextCapitalization.words, // Capitalize first letter of each word
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the mother/caregiver\'s name';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: paragraphS,
                hintText: 'MOTHER/CAREGIVER NAME',
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Child's Name Field
            TextFormField(
              controller: patientNameController,
              textCapitalization: TextCapitalization.words, // Capitalize first letter of each word
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the child\'s name';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: paragraphS,
                hintText: 'CHILD\'S NAME',
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Child's Date of Birth Field
            GestureDetector(
              onTap: () => _selectDate(context, patientDobController),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: patientDobController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the child\'s date of birth';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintStyle: paragraphS,
                    hintText: 'DATE OF BIRTH (YYYY-MM-DD)',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Gender Dropdown Field
            DropdownButtonFormField<String>(
              value: selectedSex,
              onChanged: (value) {
                setState(() {
                  selectedSex = value!;
                  _calculateStatuses();
                });
              },
              items: <String>['Male', 'Female'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintStyle: paragraphS,
                hintText: 'GENDER',
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Height Field
            TextFormField(
              controller: heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              onChanged: (value) {
                _calculateStatuses(); // Recalculate statuses after height is input
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the height (in cm)';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: paragraphS,
                hintText: 'HEIGHT (CM)',
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffixText: 'CM',
              ),
            ),
            const SizedBox(height: 15),

            // Weight Field
            TextFormField(
              controller: weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              onChanged: (value) {
                _calculateStatuses(); // Recalculate statuses after weight is input
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the weight (in kg)';
                }
                return null;
              },
              decoration: const InputDecoration(
                hintStyle: paragraphS,
                hintText: 'WEIGHT (KG)',
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                suffixText: 'KG',
              ),
            ),
            const SizedBox(height: 15),

            // Actual Date of Weighing Field
            GestureDetector(
              onTap: () => _selectDate(context, dateOfWeighingController),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: dateOfWeighingController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the actual date of weighing';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintStyle: paragraphS,
                    hintText: 'ACTUAL DATE OF WEIGHING (YYYY-MM-DD)',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button with blue background and white text
            Center(
              child: ElevatedButton(
                onPressed: () {
                  saveButtonPressed(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue background color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  elevation: 5, // Adds slight shadow effect
                ),
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(
                    color: Colors.white, // White text color
                    fontSize: 16, // Adjusted text size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
