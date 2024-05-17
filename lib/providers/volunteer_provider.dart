import 'package:damm_2024/models/gender.dart';
import 'package:damm_2024/models/volunteer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volunteer_provider.g.dart';

//TODO esto es data dummy
@riverpod
Volunteer volunteer(VolunteerRef ref) {
  return Volunteer(
    firstName: 'Santiago',
    lastName: 'Peerez',
    profileImageURL: 'https://s3-alpha-sig.figma.com/img/113f/a25a/235312cc53dcd4c8780648145d59e3c2?Expires=1716768000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=duiqwTErl69BZluQOXDER0XTapIU2JKgpHeYwI7cgu-3axOPOiIulDiR5DiFF-E3gEYCeb~LpzTE8u-ZLrfqZGo~LDigJMqEqHR2cjfzK8y8VgSrxcQpQdPgHMMY8MvzSPlKGBK9gzE5MrZOIyyqOjBUM0cE~iAX0wHxE0xoCCoxEGCDAIbFH4Dl09LSiO6hjQgUwY3GQYa6zBvrvlU8z63hbU2mRAwtSOc-Avdk3ogN9kJk1GP4EkdOJAe~~1yfs5Gj7rG7AMyk03MSslkInuZSHdDAwRC70ayhAGN6sfidIz94L-baJWT2GDdAao1gA4r9mJ9bP6APTV2kukk0rg__',
    email: 'email@email.com',
    phoneNumber: '+5491123456789',
    dateOfBirth: DateTime.now(),
    gender: Gender.man);

}