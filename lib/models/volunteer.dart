import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/gender.dart';

class Volunteer {
  final String firstName;
  final String lastName;
  final String email;
  final Gender? gender;
  final String profileImageURL;
  final DateTime? dateOfBirth;
  final String phoneNumber;
  final String uid;
  final List<String?> favoriteVolunteerings;
  String? currentVolunteering;

  Volunteer({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.profileImageURL,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.favoriteVolunteerings,
    required this.uid,
    this.currentVolunteering,
  });

  bool hasCompletedProfile() {
    print(
        'Volunteer: $this finishedSetup(${gender != null && phoneNumber.isNotEmpty && dateOfBirth != null && profileImageURL.isNotEmpty})');
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
      gender: genderFromString(data['gender'])?? null,
      profileImageURL: data['profileImageURL'] as String,
      dateOfBirth: (data['dateOfBirth'] as DateTime?),
      phoneNumber: data['phoneNumber'] as String,
      uid: data['uid'] as String,
      favoriteVolunteerings:
          List<String?>.from(data['favoriteVolunteerings'] as List),
      currentVolunteering: data['currentVolunteering'] as String?,
    );
  }

  factory Volunteer.empty() {
    return Volunteer(
      firstName: '',
      lastName: '',
      email: '',
      gender: null,
      profileImageURL: '',
      dateOfBirth: null,
      phoneNumber: '',
      favoriteVolunteerings: [],
      uid: '',
      currentVolunteering: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender?.value,
      'profileImageURL': profileImageURL,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'favoriteVolunteerings': favoriteVolunteerings,
      'currentVolunteering': currentVolunteering,
    };
  }

  factory Volunteer.fromVolunteer(Volunteer volunteer) {
    return Volunteer(
      firstName: volunteer.firstName,
      lastName: volunteer.lastName,
      email: volunteer.email,
      gender: volunteer.gender,
      profileImageURL: volunteer.profileImageURL,
      dateOfBirth: volunteer.dateOfBirth,
      phoneNumber: volunteer.phoneNumber,
      favoriteVolunteerings: List<String?>.from(volunteer.favoriteVolunteerings),
      uid: volunteer.uid,
      currentVolunteering: volunteer.currentVolunteering,
    );
  }

  @override
  String toString() {
    return 'Volunteer{firstName: $firstName, lastName: $lastName, email: $email, gender: $gender, profileImageURL: $profileImageURL, dateOfBirth: $dateOfBirth, phoneNumber: $phoneNumber, uid: $uid, favoriteVolunteerings: $favoriteVolunteerings, currentVolunteering: $currentVolunteering}';
  }

  bool hasFavorite(String opportunityId) {
    return favoriteVolunteerings.contains(opportunityId);
  }

  void applyToVolunteer(String volunteeringId) {
    if (currentVolunteering != null) {
      throw Exception('Volunteer is already enrolled in a volunteering');
    }
    currentVolunteering = volunteeringId;
  }

  void addFavoriteVolunteer(String volunteeringId) {
    if (!hasFavorite(volunteeringId)){
      favoriteVolunteerings.add(volunteeringId);
    }
  }

  void removeFavoriteVolunteer(String volunteeringId){
    if (hasFavorite(volunteeringId)){
      favoriteVolunteerings.remove(volunteeringId);
    }
  }
}


// un volunteer tiene un unico voluntariado en el que esta participando.
// un voluntariado tiene una cantidad de vacantes, una lista de aplicantes y una lista de confirmados
// el volunteer apretara postularme -> su voluntariado asociado no cambia, pero si aparece en la lista de aplicantes
// el voluntariado lo acepta -> se tiene que settear su main voluntariado al volunteer
