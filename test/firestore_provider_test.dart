import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:damm_2024/providers/firestore_provider.dart';
import 'package:damm_2024/models/volunteer_details.dart';
import 'firestore_provider_test.mocks.dart';

// Genera los mocks necesarios
@GenerateMocks([
  FirebaseFirestore,
  FirebaseStorage,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Reference,
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseStorage mockStorage;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockStorage = MockFirebaseStorage();
    mockCollectionReference = MockCollectionReference<Map<String, dynamic>>();
    mockDocumentReference = MockDocumentReference<Map<String, dynamic>>();
    mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();

    // Configurar Firestore mocks
    when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);

    // Configurar Storage mocks
    when(mockStorage.ref()).thenReturn(MockReference());
  });

  test('VolunteerDetailsProvider returns volunteer details when document exists', () async {
    final container = ProviderContainer(overrides: [
      firestoreDataSourceProvider.overrideWithValue(FirestoreDataSource(mockFirestore, mockStorage)),
    ]);

    final provider = container.read(volunteerDetailsProvider.notifier);

    when(mockDocumentSnapshot.exists).thenReturn(true);
    when(mockDocumentSnapshot.data()).thenReturn({
      'imagePath': 'path/to/image',
      'createdAt': Timestamp.now(),
      // otros campos necesarios
    });

    when(mockDocumentReference.snapshots()).thenAnswer(
      (_) => Stream.value(mockDocumentSnapshot),
    );

    await expectLater(
      provider.stream,
      emits(isA<VolunteerDetails>()),
    );
  });

  test('VolunteerDetailsProvider returns null when document does not exist', () async {
    final container = ProviderContainer(overrides: [
      firestoreDataSourceProvider.overrideWithValue(FirestoreDataSource(mockFirestore, mockStorage)),
    ]);

    final provider = container.read(volunteerDetailsProvider.notifier);

    when(mockDocumentSnapshot.exists).thenReturn(false);
    when(mockDocumentReference.snapshots()).thenAnswer(
      (_) => Stream.value(mockDocumentSnapshot),
    );

    await expectLater(
      provider.stream,
      emits(null),
    );
  });
}

