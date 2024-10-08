class Client {
  String? id; 
  String? guardian;
  String? address;
  String? name;
  String? dob;
  String? gender;
  String? height;
  String? weight;
  String? dateOfWeighing;
  String? weightForAge;
  String? heightForAge;
  String? weightForHeight;
  String? nutritionStatus;
  String? goalWeight; // Add goalWeight
  int? ageInMonths;
  String? userId;

  Client({
    this.id,
    this.guardian,
    this.address,
    this.name,
    this.dob,
    this.gender,
    this.height,
    this.weight,
    this.dateOfWeighing,
    this.weightForAge,
    this.heightForAge,
    this.weightForHeight,
    this.nutritionStatus,
    this.goalWeight, // Include goalWeight
    this.ageInMonths,
    this.userId,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'],
      guardian: json['guardian'],
      address: json['address'],
      name: json['name'],
      dob: json['dob'],
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      dateOfWeighing: json['dateOfWeighing'],
      weightForAge: json['weightForAge'],
      heightForAge: json['heightForAge'],
      weightForHeight: json['weightForHeight'],
      nutritionStatus: json['nutritionStatus'],
      goalWeight: json['goalWeight'], // Add goalWeight
      ageInMonths: json['ageInMonths'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'guardian': guardian,
      'address': address,
      'name': name,
      'dob': dob,
      'gender': gender,
      'height': height,
      'weight': weight,
      'dateOfWeighing': dateOfWeighing,
      'weightForAge': weightForAge,
      'heightForAge': heightForAge,
      'weightForHeight': weightForHeight,
      'nutritionStatus': nutritionStatus,
      'goalWeight': goalWeight, // Include goalWeight in JSON
      'ageInMonths': ageInMonths,
      'userId': userId,
    };
  }
}
