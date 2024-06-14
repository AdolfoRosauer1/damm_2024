import 'package:damm_2024/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart' as auth_provider;
import 'providers/connectivity_provider.dart' as connectivity_provider;
import 'providers/volunteer_provider.dart' as volunteer_provider;
import 'providers/location_provider.dart' as location_provider;

Future<ProviderContainer> bootstrap() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Riverpod container
  final container = ProviderContainer(overrides: [], observers: []);

  // Initialize providers
  await auth_provider.initializeProviders(container);
  await volunteer_provider.initializeProvider(container);
  connectivity_provider.init(container);
  location_provider.init(container);

  return container;
}
