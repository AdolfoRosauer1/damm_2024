// internet_status_provider.dart

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<InternetStatus> internetConnection(InternetConnectionRef ref) {
  return InternetConnection().onStatusChange;
}
