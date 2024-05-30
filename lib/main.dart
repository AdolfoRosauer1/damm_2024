import 'package:damm_2024/bootstrap.dart';
import 'package:damm_2024/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/tokens/colors.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Start splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // print('Splash Screen UP!');

  // initialize
  await bootstrap();

  // router
  CustomNavigationHelper.instance;

  runApp(const ProviderScope(child: MyApp()));

  // remove splash screen
  FlutterNativeSplash.remove();
  // print('Splash Screen DOWN!');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          tabBarTheme: TabBarTheme(
            overlayColor: MaterialStateProperty.all(
                ProjectPalette.neutral2.withOpacity(0.1)),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(width: 3.0, color: ProjectPalette.neutral1)),
                color: ProjectPalette.secondary6),
            labelColor: ProjectPalette.neutral1,
            unselectedLabelColor: ProjectPalette.neutral4,
          ),
        ),
        routerConfig: CustomNavigationHelper.router);
  }
}
