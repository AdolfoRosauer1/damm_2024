// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:damm_2024/models/volunteer.dart';
// import 'package:damm_2024/providers/volunteer_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class ProfileService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   void finishSetup(User user, Map<String, dynamic> data) async {
//     try {
//       // CREATE A USER DOCUMENT IN FIREBASE
//
//       // Create a mutable copy of the data map
//       Map<String, dynamic> mutableData = Map<String, dynamic>.from(data);
//       mutableData['profileImageURL'] = mutableData['profilePicture'];
//       mutableData.remove('profilePicture');
//       // SET riverpod volunteer
//
//       List<String> nameParts = user.displayName.toString().split(' ');
//       if (nameParts.length > 1) {
//         mutableData['firstName'] = nameParts[0];
//         mutableData['lastName'] = nameParts[1];
//       } else {
//         mutableData['firstName'] = nameParts[0];
//         mutableData['lastName'] = '';
//       }
//       await _firestore
//           .collection('volunteer')
//           .doc(user.uid)
//           .set(mutableData)
//           .onError((e, _) => print("Error writing document: $e"));
//
//       Volunteer toSet = Volunteer.fromJson(mutableData);
//       // TODO implement correct use of Repository with @riverpod
//       final container = ProviderContainer();
//       print(
//           'Initial volunteer in provider: firstName: ${container.read(currentUserProvider)!.firstName}, number: ${container.read(currentUserProvider)!.phoneNumber}');
//       container.read(currentUserProvider.notifier).set(toSet);
//     } catch (e) {
//       print('Error finishing setup: $e');
//     }
//   }
//
//   Future<Volunteer?> getVolunteerById(String id) async {
//     try {
//       print('Fetching Volunteer by ID: $id');
//       DocumentSnapshot doc =
//           await _firestore.collection('volunteer').doc(id).get();
//       print('Fetched Firestore Document: $doc');
//       if (doc.exists) {
//         var data = doc.data() as Map<String, dynamic>;
//         Timestamp ts = data['dateOfBirth'] as Timestamp;
//         data['dateOfBirth'] = ts.toDate();
//         return Volunteer.fromJson(data);
//       }
//       return null;
//     } catch (e) {
//       print('Error getting volunteer by id: $e');
//       return null;
//     }
//   }
// }
