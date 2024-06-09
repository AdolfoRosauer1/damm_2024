import 'package:damm_2024/models/gender.dart';

class Volunteer {
  final String firstName;
  final String lastName;
  final String email;
  final String? gender;  // Now stores the string representation of gender
  final String profileImageURL;
  final DateTime? dateOfBirth;
  final String phoneNumber;
  final String uid;

  Volunteer({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.profileImageURL,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.uid
  });

  bool hasCompletedProfile() {
    print('Volunteer: finishedSetup(${gender != null && phoneNumber.isNotEmpty && dateOfBirth != null && profileImageURL.isNotEmpty})');
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
      gender: data['gender'] as String?,
      profileImageURL: data['profileImageURL'] as String,
      dateOfBirth: (data['dateOfBirth'] as Timestamp?)?.toDate(),
      phoneNumber: data['phoneNumber'] as String,
      uid: data['uid'] as String,
    );
  }

  @override
  String toString() {
    return 'Volunteer{firstName: $firstName, lastName: $lastName, email: $email, gender: $gender, profileImageURL: $profileImageURL, dateOfBirth: $dateOfBirth, phoneNumber: $phoneNumber, uid: $uid}';
  }
}

// un volunteer tiene un unico voluntariado en el que esta participando.
// un voluntariado tiene una cantidad de vacantes, una lista de aplicantes y una lista de confirmados
// el volunteer apretara postularme -> su voluntariado asociado no cambia, pero si aparece en la lista de aplicantes
// el voluntariado lo acepta -> se tiene que settear su main voluntariado al volunteer
