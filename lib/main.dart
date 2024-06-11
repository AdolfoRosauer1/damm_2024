import 'package:damm_2024/bootstrap.dart';
import 'package:damm_2024/config/router.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:go_router/go_router.dart';

//import 'package:flutter_localization/flutter_localization.dart';
import 'widgets/tokens/colors.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Start splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // print('Splash Screen UP!');

  // initialize
  ProviderContainer container = await bootstrap();


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: false,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    onDidReceiveNotificationResponse: (details) {
      print('Notification received');
      print(details.payload);
      if (details.payload != null) {
        CustomNavigationHelper.parentNavigatorKey.currentState?.context
            .go(details.payload!);
      }
    },
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          payload: message.data['deep_link'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
              // other properties...
            ),
          ));
    }
  });

  // router
  CustomNavigationHelper.instance;


    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  runApp(ProviderScope(parent: container, child: MyApp()));

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
        localizationsDelegates: const [
          AppLocalizations
              .delegate, //Comentar esto si no funciona. Y hacer flutter run. Ahi debería funcionar
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
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
