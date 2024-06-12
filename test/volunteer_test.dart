import 'package:flutter_test/flutter_test.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/models/gender.dart';

void main() {
  group('Volunteer', () {
    test('fromJson creates a valid Volunteer object', () {
      final json = {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'gender': 'Hombre',
        'profileImageURL': 'https://example.com/image.png',
        'dateOfBirth': DateTime.now(),
        'phoneNumber': '1234567890',
        'uid': 'uid123',
        'favoriteVolunteerings': []
      };

      final volunteer = Volunteer.fromJson(json);

      expect(volunteer.firstName, 'John');
      expect(volunteer.lastName, 'Doe');
      expect(volunteer.email, 'john.doe@example.com');
      expect(volunteer.gender, Gender.man);
      expect(volunteer.profileImageURL, 'https://example.com/image.png');
      expect(volunteer.phoneNumber, '1234567890');
      expect(volunteer.uid, 'uid123');
      expect(volunteer.favoriteVolunteerings, []);
    });

    test('hasCompletedProfile returns true when all fields are filled', () {
      final volunteer = Volunteer(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        gender: Gender.man,
        profileImageURL: 'https://example.com/image.png',
        dateOfBirth: DateTime.now(),
        phoneNumber: '1234567890',
        uid: 'uid123',
        favoriteVolunteerings: []
      );

      expect(volunteer.hasCompletedProfile(), isTrue);
    });

    test('hasCompletedProfile returns false when any field is missing', () {
      final volunteer = Volunteer(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        gender: null,
        profileImageURL: '',
        dateOfBirth: null,
        phoneNumber: '',
        uid: 'uid123',
        favoriteVolunteerings: []
      );

      expect(volunteer.hasCompletedProfile(), isFalse);
    });
  });
}

