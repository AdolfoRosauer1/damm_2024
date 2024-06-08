import 'package:damm_2024/models/gender.dart';

class Volunteer {
  final String firstName;
  final String lastName;
  final String email;
  final Gender? gender;
  final String profileImageURL;
  final DateTime? dateOfBirth;
  final String phoneNumber;

  Volunteer({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.profileImageURL,
    required this.dateOfBirth,
    required this.phoneNumber,
  });

  bool hasCompletedProfile() {
    print(
        'Volunteer: finishedSetup(${gender != null && phoneNumber.isNotEmpty && dateOfBirth != null && profileImageURL.isNotEmpty})');
    return gender != null &&
        phoneNumber.isNotEmpty &&
        dateOfBirth != null &&
        profileImageURL.isNotEmpty;
  }

  factory Volunteer.fromJson(Map<String, dynamic> data) {
    return Volunteer(
        firstName: data['firstName'] as String,
        lastName: data['lastName'] as String,
        email: data['email'] as String,
        gender: genderFromString(data['gender']),
        profileImageURL: data['profileImageURL'] as String,
        dateOfBirth: data['dateOfBirth'] as DateTime?,
        phoneNumber: data['phoneNumber'] as String);
  }
}
