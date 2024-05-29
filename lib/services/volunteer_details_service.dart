import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damm_2024/models/volunteer_details.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VolunteerDetailsService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<VolunteerDetails>> getVolunteers() async {
    List<VolunteerDetails> volunteers = [];
    QuerySnapshot snapshot = await _firestore.collection('volunteerOpportunities').get();
    for (var element in snapshot.docs) {
      var data = element.data() as Map<String,dynamic>;
      var imageUrl = await _storage.ref().child(data['imagePath']).getDownloadURL();
      data['id'] = element.id;
      data['imageUrl'] = imageUrl;
      Timestamp timestamp = data['createdAt'];
      data['createdAt'] = timestamp.toDate();
      volunteers.add(VolunteerDetails.fromJson(data));
    }
  
    return volunteers;
  }

  Future<VolunteerDetails?> getVolunteerById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('volunteerOpportunities').doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        var imageUrl = await _storage.ref().child(data['imagePath']).getDownloadURL();
        data['id'] = id;
        data['imageUrl'] = imageUrl;
        Timestamp timestamp = data['createdAt'];
        data['createdAt'] = timestamp.toDate();
        return VolunteerDetails.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting volunteer details by id: $e");
      return null;
    }
  }

}