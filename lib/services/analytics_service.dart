import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static FirebaseAnalytics? _analyticsInstance;

  // Constructor sin argumentos
  AnalyticsService() {
    _analyticsInstance ??= FirebaseAnalytics.instance;
  }

  // Constructor para pruebas
  AnalyticsService.forTest(FirebaseAnalytics analytics) {
    _analyticsInstance = analytics;
  }

  // Método estático para configurar FirebaseAnalytics para pruebas
  static void setupForTest(FirebaseAnalytics analytics) {
    _analyticsInstance = analytics;
  }

  // Métodos para registrar eventos
  void logApplyToVolunteer(String volunteerOpportunityId, String userId) {
    _analyticsInstance?.logEvent(
      name: 'apply_to_volunteer',
      parameters: <String, dynamic>{
        'volunteer_opportunity_id': volunteerOpportunityId,
        'user_id': userId,
      },
    );
  }

  void logUnapplyToVolunteer(String volunteerOpportunityId, String userId) {
    _analyticsInstance?.logEvent(
      name: 'unapply_to_volunteer',
      parameters: <String, dynamic>{
        'volunteer_opportunity_id': volunteerOpportunityId,
        'user_id': userId,
      },
    );
  }

  void logCompleteVolunteerProfile(String userId) {
    _analyticsInstance?.logEvent(
      name: 'complete_volunteer_profile',
      parameters: <String, dynamic>{
        'user_id': userId,
      },
    );
  }

  void logShareNews(String newsId, String userId) {
    _analyticsInstance?.logEvent(
      name: 'share_news',
      parameters: <String, dynamic>{
        'news_id': newsId,
        'user_id': userId,
      },
    );
  }

  void logSignup(String uid) {
    _analyticsInstance?.logEvent(
      name: 'signup',
      parameters: <String, dynamic>{
        'user_id': uid,
      },
    );
  }
}
