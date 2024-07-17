import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfigProvider = Provider<FirebaseRemoteConfig>((ref) {
  final remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 5),
  ));

  remoteConfig.onConfigUpdated.listen((event) async {
    await remoteConfig.activate();
  });

  return remoteConfig;
});

final favoritesEnabledProvider = FutureProvider<bool>((ref) async {
  final remoteConfig = ref.watch(remoteConfigProvider);
  await remoteConfig.fetchAndActivate();
  return remoteConfig.getBool('favorites');
});

final shareNewsEnabledProvider = FutureProvider<bool>((ref) async {
  final remoteConfig = ref.watch(remoteConfigProvider);
  await remoteConfig.fetchAndActivate();
  return remoteConfig.getBool('share_news');
});

final mapEnabledProvider = FutureProvider<bool>((ref) async {
  final remoteConfig = ref.watch(remoteConfigProvider);
  await remoteConfig.fetchAndActivate();
  return remoteConfig.getBool('mapa');
});
