import 'package:app_salingtanya/modules/auth/view/auth_page.dart';
import 'package:app_salingtanya/modules/dashboard/view/dashboard_page.dart';
import 'package:app_salingtanya/modules/room/view/detail_room_page.dart';
import 'package:app_salingtanya/modules/room/view/select_questions_page.dart';
import 'package:app_salingtanya/modules/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationHelper {
  NavigationHelper({required this.isLoggedIn});

  bool isLoggedIn = false;

  void goNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    goRouter.goNamed(
      name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  void pushNamed(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
    Object? extra,
  }) {
    goRouter.pushNamed(
      name,
      params: params,
      queryParams: queryParams,
      extra: extra,
    );
  }

  late final goRouter = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'SplashPage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        redirect: (state) {
          if (!isLoggedIn) return '/auth';

          return '/dashboard';
        },
        routes: [
          GoRoute(
            path: 'auth',
            name: 'AuthPage',
            builder: (context, state) => const AuthPage(),
            redirect: (state) {
              if (!isLoggedIn) return null;

              return '/dashboard';
            },
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        name: 'DashboardPage',
        builder: (context, state) => const DashboardPage(),
        redirect: (state) {
          if (!isLoggedIn) return '/';

          return null;
        },
        routes: [
          GoRoute(
            path: 'rooms',
            name: 'ListRoomPage',
            redirect: (state) {
              return '/';
            },
          ),
          GoRoute(
            path: 'rooms/:rid',
            name: 'DetailRoomPage',
            builder: (context, state) =>
                DetailRoomPage(roomId: state.params['rid']!),
            routes: [
              GoRoute(
                path: 'select-questions',
                name: 'SelectQuestionsPage',
                builder: (context, state) => SelectQuestionsPage(
                  roomId: state.params['rid']!,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
