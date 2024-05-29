import 'package:damm_2024/providers/auth_provider.dart';
import 'package:damm_2024/screens/access_screen.dart';
import 'package:damm_2024/screens/apply_screen.dart';
import 'package:damm_2024/screens/news_details_screen.dart';
import 'package:damm_2024/screens/news_screen.dart';
import 'package:damm_2024/screens/profile_screen.dart';
import 'package:damm_2024/screens/tabs.dart';
import 'package:damm_2024/screens/volunteer_details_screen.dart';
import 'package:damm_2024/screens/welcome_screen.dart';
import 'package:damm_2024/widgets/cells/forms/login_form.dart';
import 'package:damm_2024/widgets/cells/forms/personal_data_form.dart';
import 'package:damm_2024/widgets/cells/forms/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomNavigationHelper {
  static final CustomNavigationHelper _instance =
      CustomNavigationHelper._internal();

  static CustomNavigationHelper get instance => _instance;

  static late final GoRouter router;

  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> newsTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> applyTabNavigatorKey =
      GlobalKey<NavigatorState>();

  BuildContext get context =>
      router.routerDelegate.navigatorKey.currentContext!;

  GoRouterDelegate get routerDelegate => router.routerDelegate;

  GoRouteInformationParser get routeInformationParser =>
      router.routeInformationParser;

  factory CustomNavigationHelper() {
    return _instance;
  }

  CustomNavigationHelper._internal() {
    final authProvider = firebaseAuthProvider;

    final routes = [
      GoRoute(path: "/", builder: (_, __) => const WelcomeScreen()),
      GoRoute(
          path: AccessScreen.route, builder: (_, __) => const AccessScreen()),
      GoRoute(
          path: RegisterForm.route, builder: (_, __) => const RegisterForm()),
      GoRoute(path: LoginForm.route, builder: (_, __) => const LoginForm()),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: applyTabNavigatorKey,
            routes: [
              GoRoute(
                path: ApplyScreen.route,
                parentNavigatorKey: applyTabNavigatorKey,
                routes: [
                  GoRoute(
                    path: VolunteerDetailsScreen.route,
                    parentNavigatorKey: parentNavigatorKey,
                    pageBuilder: (context, state) {
                      return getPage(
                        child: VolunteerDetailsScreen(
                            id: (state.pathParameters['id']!)),
                        state: state,
                      );
                    },
                  )
                ],
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: ApplyScreen(),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileTabNavigatorKey,
            routes: [
              GoRoute(
                  path: ProfileScreen.route,
                  pageBuilder: (context, state) {
                    return getPage(
                      child: const ProfileScreen(),
                      state: state,
                    );
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: parentNavigatorKey,
                      path: PersonalDataForm.route,
                      pageBuilder: (context, state) {
                        return getPage(
                          child: const PersonalDataForm(),
                          state: state,
                        );
                      },
                    )
                  ]),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: newsTabNavigatorKey,
            routes: [
              GoRoute(
                  path: NewsScreen.route,
                  pageBuilder: (context, state) {
                    return getPage(
                      child: const NewsScreen(),
                      state: state,
                    );
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: parentNavigatorKey,
                      path: NewsDetailsScreen.route,
                      pageBuilder: (context, state) {
                        return getPage(
                          child: NewsDetailsScreen(
                              id: (state.pathParameters['id']!)),
                          state: state,
                        );
                      },
                    )
                  ]),
            ],
          ),
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: Tabs(
              child: navigationShell,
            ),
            state: state,
          );
        },
      ),
    ];

    router = GoRouter(
        navigatorKey: parentNavigatorKey,
        routes: routes,
        initialLocation: "/access",
        redirect: (context, state) {
          final container = ProviderContainer();
          final authState = container.read(authProvider).currentUser;
          print('authState = $authState');

          if (authState == null) {
            print('No redirection');
            return null;
          }
          print('redirect');
          return '/apply';
        });
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
