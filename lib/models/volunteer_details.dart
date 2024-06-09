import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerDetails {
  String id;
  String imageUrl;
  String type;
  String title;
  String mission;
  String details;
  GeoPoint location;
  String address;
  String requirements;
  String timeAvailability;
  int vacancies;
  List<String> pendingApplicants;
  List<String> confirmedApplicants;
  DateTime createdAt;

  VolunteerDetails(
      {required this.id,
      required this.imageUrl,
      required this.type,
      required this.title,
      required this.mission,
      required this.details,
      required this.location,
      required this.address,
      required this.requirements,
      required this.timeAvailability,
      required this.vacancies,
      required this.pendingApplicants,
      required this.confirmedApplicants,
      required this.createdAt});

  static VolunteerDetails fromJson(Map<String, dynamic> data) {
    return VolunteerDetails(
        id: data['id'],
        imageUrl: data['imageUrl'],
        type: data['type'],
        title: data['title'],
        mission: data['mission'],
        details: data['details'],
        location: data['location'],
        address: data['address'],
        requirements: data['requirements'],
        timeAvailability: data['timeAvailability'],
        vacancies: data['vacancies'],
        pendingApplicants: data['pendingApplicants'],
        confirmedApplicants: data['confirmedApplicants'],
        createdAt: data['createdAt']);
  }

  bool isUserPending(String userId) {
    return this.pendingApplicants.contains(userId);
  }

  bool isUserConfirmed(String userId) {
    return this.confirmedApplicants.contains(userId);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'type': type,
      'title': title,
      'mission': mission,
      'details': details,
      'location': location,
      'address': address,
      'requirements': requirements,
      'timeAvailability': timeAvailability,
      'vacancies': vacancies,
      'pendingApplicants': pendingApplicants,
      'confirmedApplicants': confirmedApplicants,
      'createdAt': createdAt,
    };
  }
}
