import 'package:damm_2024/models/volunteer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volunteer_provider.g.dart';

//TODO esto es data dummy
@riverpod
Volunteer volunteer(VolunteerRef ref) {
  return Volunteer(
    firstName: 'Santiago',
    lastName: 'Peerez',
    profileImageURL: 'https://s3-alpha-sig.figma.com/img/113f/a25a/235312cc53dcd4c8780648145d59e3c2?Expires=1715558400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Tn8SwpG3FBhJDESzmd0bGCmZXKDvf48YJGofovBB5GapiLrFoyklcKnnH0seDcvsBxLEhyQ0iDg76V-qwbHJ2sjOoVbsF381PJEh3M2D2vzG5iFYB5TN5I-sFGR~Eid54jOznww~O1r-nrmFR-sOFjJRlWw1h~onmwQ0RWkfECbYu2e5pz-Pevc6MCqN9dRsQNbgwCKufHbgEtogXLlnMpS5k4WL8WKTRRgv~OAJtPhn9pmr6h4oV0lTWqPf1K~BE2kO18au2SC3UhU3BC68V6dW7uURtduW1dHJZej7vTav6D96kPG-H9PSsPEIDyZ57P6yZ11~iBzeE~jhnAvHsg__',
    email: 'email@email.com',
    phoneNumber: '+5491123456789',
    dateOfBirth: DateTime.now(),
    gender: 'male');

}