import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:irohasu_blog/deferred_router.dart';
import 'package:irohasu_blog/main.dart';

import 'detail_post_page.dart' deferred as detail_post;
import 'home_page.dart' deferred as home_page;
import 'shared/text.dart';

class AppRouter {
  static const home = 'home';
  static const posts = 'posts';

  static final router = GoRouter(
    navigatorKey: AppGlobals.rootNavKey,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        name: home,
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: DeferredRouter(
            future: home_page.loadLibrary(),
            builder: (_) => home_page.HomePage(),
          ),
        ),
      ),
      GoRoute(
        name: posts,
        path: '/posts/:endpoint',
        pageBuilder: (context, state) {
          // final id = state.pathParameters['endpoint']!.split('/').last;
          return MaterialPage(
            key: state.pageKey,
            child: DeferredRouter(
              future: detail_post.loadLibrary(),
              builder: (_) => detail_post.DetailPostPage(
                id: state.pathParameters['endpoint'] ?? '',
              ),
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const IrohaText.semibold('Error Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const IrohaText.regular('Go to home page'),
        ),
      ),
    );
  }
}
