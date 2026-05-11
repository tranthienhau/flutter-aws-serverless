import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/items/items_page.dart';
import '../features/items/item_detail_page.dart';
import '../features/profile/profile_page.dart';
import 'auth/sign_in_page.dart';
import 'auth/auth_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (ctx, state) {
      final signedIn = ref.watch(authControllerProvider).signedIn;
      final loggingIn = state.matchedLocation == '/sign-in';
      if (!signedIn && !loggingIn) return '/sign-in';
      if (signedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/sign-in', builder: (_, __) => const SignInPage()),
      GoRoute(path: '/', builder: (_, __) => const ItemsPage()),
      GoRoute(path: '/items/:id', builder: (_, s) => ItemDetailPage(id: s.pathParameters['id']!)),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
    ],
  );
});
