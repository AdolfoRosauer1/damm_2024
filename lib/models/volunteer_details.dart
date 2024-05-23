class VolunteerDetails{
  int id;
  String imagePath;
  String type;
  String title;
  String mission;
  String details;
  double latitude;
  double longitude;
  String address;
  String requirements;
  int vacancies;
  DateTime createdAt;

  VolunteerDetails({
    required this.id,
    required this.imagePath,
    required this.type,
    required this.title,
    required this.mission,
    required this.details,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.requirements,
    required this.vacancies,
    required this.createdAt
  });
}