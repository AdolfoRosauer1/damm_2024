import 'package:flutter_test/flutter_test.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:damm_2024/models/gender.dart';

void main() {
  group('Volunteer Application Tests', () {
    test('User can enroll in a volunteering', () {
      final volunteer = Volunteer(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        gender: Gender.man,
        profileImageURL: 'https://example.com/image.png',
        dateOfBirth: DateTime(1990, 1, 1),
        phoneNumber: '1234567890',
        uid: 'uid123',
        favoriteVolunteerings: [],
      );

      volunteer.applyToVolunteer('vol1');

      expect(volunteer.currentVolunteering, 'vol1');
    });

    test('User cannot enroll in more than one volunteering at a time', () {
      final volunteer = Volunteer(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        gender: Gender.man,
        profileImageURL: 'https://example.com/image.png',
        dateOfBirth: DateTime(1990, 1, 1),
        phoneNumber: '1234567890',
        uid: 'uid123',
        favoriteVolunteerings: [],
      );

      volunteer.applyToVolunteer('vol1');

      expect(() => volunteer.applyToVolunteer('vol2'), throwsException);
    });

    test('User can add volunteerings to favorites', () {
      final volunteer = Volunteer(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        gender: Gender.man,
        profileImageURL: 'https://example.com/image.png',
        dateOfBirth: DateTime(1990, 1, 1),
        phoneNumber: '1234567890',
        uid: 'uid123',
        favoriteVolunteerings: [],
      );

      volunteer.addFavoriteVolunteer('vol1');

      expect(volunteer.hasFavorite('vol1'), true);
    });

    test('User can apply correctly to a volunteering', () {
      final volunteer = Volunteer(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        gender: Gender.man,
        profileImageURL: 'https://example.com/image.png',
        dateOfBirth: DateTime(1990, 1, 1),
        phoneNumber: '1234567890',
        uid: 'uid123',
        favoriteVolunteerings: [],
      );

      volunteer.applyToVolunteer('vol1');
      volunteer.addFavoriteVolunteer('vol2');

      expect(volunteer.currentVolunteering, 'vol1');
      expect(volunteer.hasFavorite('vol2'), true);
    });
  });
}


