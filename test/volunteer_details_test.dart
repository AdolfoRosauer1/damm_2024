import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Mocks para FirebaseFirestore y FirebaseStorage
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockReference extends Mock implements Reference {}

class MockDownloadTask extends Mock implements DownloadTask {}

void main() {
  late VolunteerDetailsService service;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseStorage mockStorage;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    service = VolunteerDetailsService(
      firestore: mockFirestore,
      storage: mockStorage,
    );
  });

  group('VolunteerDetailsService Tests', () {
    test(
        'areVolunteersAvailable returns true when there are volunteer opportunities',
        () async {
      // Configuración del mock para que el método collection('volunteerOpportunities').get() retorne un QuerySnapshot simulado con documentos
      final mockCollectionReference = MockCollectionReference();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();

      // Configurar el mock para collection
      when(mockFirestore.collection('volunteerOpportunities'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);

      // Llamada al método que se está probando
      final result = await service.areVolunteersAvailable();

      // Verificación del resultado
      expect(result, true);
    });

    test('getVolunteerById returns VolunteerDetails when document exists',
        () async {
      // Configuración del mock para que el método collection('volunteerOpportunities').doc('vol1').get() retorne un DocumentSnapshot simulado con datos
      final mockCollectionReference = MockCollectionReference();
      final mockDocumentSnapshot = MockDocumentSnapshot();
      when(mockFirestore.collection('volunteerOpportunities'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc('vol1').get())
          .thenAnswer((_) async => mockDocumentSnapshot);
      when(mockDocumentSnapshot.exists).thenReturn(true);
      when(mockDocumentSnapshot.data()).thenReturn({
        'title': 'Sample Volunteer',
        'imagePath': 'path/to/image.png',
        'createdAt': Timestamp.now(),
        'vacancies': 10,
        'location': const GeoPoint(37.7749, -122.4194),
      });
      // Configuración del mock para que el método ref().child('path/to/image.png').getDownloadURL() retorne una URL simulada
      final mockReference = MockReference();
      when(mockStorage.ref().child('path/to/image.png'))
          .thenReturn(mockReference);
      when(mockReference.getDownloadURL())
          .thenAnswer((_) async => 'https://example.com/image.png');

      // Llamada al método que se está probando
      final result = await service.getVolunteerById('vol1');

      // Verificación del resultado
      expect(result, isNotNull);
      expect(result!.title, 'Sample Volunteer');
      expect(result.imageUrl, 'https://example.com/image.png');
    });

    test('getVolunteers returns list of VolunteerDetails', () async {
      // Configuración del mock para que el método collection('volunteerOpportunities').get() retorne un QuerySnapshot simulado con documentos
      final mockCollectionReference = MockCollectionReference();
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
      when(mockFirestore.collection('volunteerOpportunities'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.get())
          .thenAnswer((_) async => mockQuerySnapshot);
      when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
      when(mockQueryDocumentSnapshot.data()).thenReturn({
        'title': 'Sample Volunteer',
        'imagePath': 'path/to/image.png',
        'createdAt': Timestamp.now(),
        'vacancies': 10,
        'location': const GeoPoint(37.7749, -122.4194),
      });
      // Configuración del mock para que el método ref().child('path/to/image.png').getDownloadURL() retorne una URL simulada
      final mockReference = MockReference();
      when(mockStorage.ref().child('path/to/image.png'))
          .thenReturn(mockReference);
      when(mockReference.getDownloadURL())
          .thenAnswer((_) async => 'https://example.com/image.png');

      // Llamada al método que se está probando
      final result = await service.getVolunteers();

      // Verificación del resultado
      expect(result, isNotEmpty);
      expect(result.first.title, 'Sample Volunteer');
      expect(result.first.imageUrl, 'https://example.com/image.png');
    });
  });
}
