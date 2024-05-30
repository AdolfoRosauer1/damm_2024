import 'package:damm_2024/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart' as authProvider;

Future<ProviderContainer> bootstrap() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Riverpod container
  final container = ProviderContainer(overrides: [], observers: []);

  // Initialize providers
  await authProvider.initializeProviders(container);

  // sleep(const Duration(seconds: 5));

  return container;
}
