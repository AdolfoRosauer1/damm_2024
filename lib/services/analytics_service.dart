import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService{
  void logApplyToVolunteer(String volunteerOpportunityId, String userId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'apply_to_volunteer',
      parameters: <String, dynamic>{
        'volunteer_opportunity_id': volunteerOpportunityId,
        'user_id': userId,
      },
    );
  }

  void logUnapplyToVolunteer(String volunteerOpportunityId, String userId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'unapply_to_volunteer',
      parameters: <String, dynamic>{
        'volunteer_opportunity_id': volunteerOpportunityId,
        'user_id': userId,
      },
    );
  }

  void logCompleteVolunteerProfile(String userId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'complete_volunteer_profile',
      parameters: <String, dynamic>{
        'user_id': userId,
      },
    );
  }

  void logShareNews(String newsId, String userId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'share_news',
      parameters: <String, dynamic>{
        'news_id': newsId,
        'user_id': userId,
      },
    );
  }

  void logSignup(String uid) {
    FirebaseAnalytics.instance.logEvent(
      name: 'signup',
      parameters: <String, dynamic>{
        'user_id': uid,
      },
    );
  }
}