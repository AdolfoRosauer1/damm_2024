import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:damm_2024/services/analytics_service.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';

// Mock de FirebaseAnalytics
class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

// Mock de FirebaseCoreHostApi
class MockFirebaseCoreHostApi extends Mock implements FirebaseCoreHostApi {}

void main() {
  // Asegúrate de que el binding se inicializa antes de cualquier prueba
  TestWidgetsFlutterBinding.ensureInitialized();

  // Configuración inicial de la plataforma para pruebas
  setupFirebaseCoreMocks();

  setUpAll(() async {
    // Inicializar Firebase antes de correr las pruebas
    await Firebase.initializeApp();
  });

  group('AnalyticsService Tests', () {
    late AnalyticsService analyticsService;
    late MockFirebaseAnalytics mockFirebaseAnalytics;

    setUp(() {
      // Inicializamos el mock de FirebaseAnalytics
      mockFirebaseAnalytics = MockFirebaseAnalytics();

      // Inicializamos AnalyticsService para pruebas
      AnalyticsService.setupForTest(mockFirebaseAnalytics);
      analyticsService = AnalyticsService();
    });

    test('Log apply to volunteer event', () async {
      when(mockFirebaseAnalytics.logEvent(
        name: 'apply_to_volunteer',
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async => Future.value());

      analyticsService.logApplyToVolunteer('vol1', 'uid123');

      verify(mockFirebaseAnalytics.logEvent(
        name: 'apply_to_volunteer',
        parameters: <String, dynamic>{
          'volunteer_opportunity_id': 'vol1',
          'user_id': 'uid123',
        },
      )).called(1);
    });

    test('Log unapply to volunteer event', () async {
      when(mockFirebaseAnalytics.logEvent(
        name: 'unapply_to_volunteer',
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async => Future.value());

      analyticsService.logUnapplyToVolunteer('vol1', 'uid123');

      verify(mockFirebaseAnalytics.logEvent(
        name: 'unapply_to_volunteer',
        parameters: <String, dynamic>{
          'volunteer_opportunity_id': 'vol1',
          'user_id': 'uid123',
        },
      )).called(1);
    });

    test('Log complete volunteer profile event', () async {
      when(mockFirebaseAnalytics.logEvent(
        name: 'complete_volunteer_profile',
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async => Future.value());

      analyticsService.logCompleteVolunteerProfile('uid123');

      verify(mockFirebaseAnalytics.logEvent(
        name: 'complete_volunteer_profile',
        parameters: <String, dynamic>{
          'user_id': 'uid123',
        },
      )).called(1);
    });

    test('Log share news event', () async {
      when(mockFirebaseAnalytics.logEvent(
        name: 'share_news',
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async => Future.value());

      analyticsService.logShareNews('news1', 'uid123');

      verify(mockFirebaseAnalytics.logEvent(
        name: 'share_news',
        parameters: <String, dynamic>{
          'news_id': 'news1',
          'user_id': 'uid123',
        },
      )).called(1);
    });

    test('Log signup event', () async {
      when(mockFirebaseAnalytics.logEvent(
        name: 'signup',
        parameters: anyNamed('parameters'),
      )).thenAnswer((_) async => Future.value());

      analyticsService.logSignup('uid123');

      verify(mockFirebaseAnalytics.logEvent(
        name: 'signup',
        parameters: <String, dynamic>{
          'user_id': 'uid123',
        },
      )).called(1);
    });
  });
}

// Función para configurar mocks de Firebase Core
void setupFirebaseCoreMocks() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_core'),
    (MethodCall methodCall) async {
      if (methodCall.method == 'Firebase#initializeCore') {
        return {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'fakeApiKey',
            'appId': 'fakeAppId',
            'messagingSenderId': 'fakeSenderId',
            'projectId': 'fakeProjectId',
          },
          'pluginConstants': {},
        };
      }
      return null;
    },
  );
}
