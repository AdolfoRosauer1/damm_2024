import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerDetails{
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
  DateTime createdAt;

  VolunteerDetails({
    required this.id,
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
    required this.createdAt
  });

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
      createdAt: data['createdAt']
    );
  }
}