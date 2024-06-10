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
  int remainingVacancies;
  List<String?> pendingApplicants;
  List<String?> confirmedApplicants;
  DateTime createdAt;
  double cost;

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
      required this.remainingVacancies,
      required this.pendingApplicants,
      required this.confirmedApplicants,
      required this.cost,
      required this.createdAt});

  static VolunteerDetails fromJson(Map<String, dynamic> data) {
    return VolunteerDetails(
        id: data['id'] as String,
        imageUrl: data['imageUrl'] as String,
        type: data['type'] as String,
        title: data['title'] as String,
        mission: data['mission'] as String,
        details: data['details'] as String,
        location: data['location'] as GeoPoint,
        address: data['address'] as String,
        requirements: data['requirements'] as String,
        timeAvailability: data['timeAvailability'] as String,
        vacancies: data['vacancies'] as int,
        cost: data['cost'] as double,
        remainingVacancies: data['remainingVacancies'] as int,
        pendingApplicants:
            List<String?>.from(data['pendingApplicants'] as List),
        confirmedApplicants:
            List<String?>.from(data['confirmedApplicants'] as List),
        createdAt: data['createdAt'] as DateTime);
  }

  bool isUserPending(String userId) {
    return pendingApplicants.contains(userId);
  }

  bool isUserConfirmed(String userId) {
    return confirmedApplicants.contains(userId);
  }

  void calculateVacancies() {
    remainingVacancies = vacancies - confirmedApplicants.length;
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
      'cost': cost,
    };
  }
}
