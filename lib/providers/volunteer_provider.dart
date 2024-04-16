import 'package:damm_2024/models/volunteer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'volunteer_provider.g.dart';

//TODO esto es data dummy
@riverpod
Volunteer volunteer(VolunteerRef ref) {
  return Volunteer(
    firstName: 'Santiago',
    lastName: 'López',
    profileImageURL: 'https://s3-alpha-sig.figma.com/img/113f/a25a/235312cc53dcd4c8780648145d59e3c2?Expires=1713744000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=P7~GspZy9w~6SVCZ46rykZx1vy8LmL02Qgb9uYkF0xmXvaox4jycbD9TYotWVsyCfwZTmtOgShzz5KWFOgTgeX-fjJBBgnWonGmTmBMFdpAPPNDLvZSbyt3ZlfEv7FjZPr-Lr-Hm2UpcChqFA4iThql1IDJQn88cPT2P46S-oyF~3N4JN-jsm8xFC-ZBqmHZFIxtwJ7hXP2ggV5gcNiF3CDW~kpRPaV8le8yTD2-6SCpgaw1smhXoeSUkstVXe231pLc4HWH0QqMIIKtUw2GL~jEmQzVuXPhluD-jon22xVW5nsl4Tk8vnlS-U63vMeydvMJj9EuxYTu3-dfxoYMRw__',
    email: 'email@email.com',
    phoneNumber: '+5491165863216',
    dateOfBirth: DateTime.now(),
    gender: 'Masculino');

}