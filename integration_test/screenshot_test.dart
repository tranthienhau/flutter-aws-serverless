import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_aws_serverless/core/api/items_api.dart';
import 'package:flutter_aws_serverless/core/auth/auth_controller.dart';
import 'package:flutter_aws_serverless/core/auth/sign_in_page.dart';
import 'package:flutter_aws_serverless/core/theme.dart';
import 'package:flutter_aws_serverless/features/items/items_page.dart';
import 'package:flutter_aws_serverless/features/items/item_detail_page.dart';
import 'package:flutter_aws_serverless/features/profile/profile_page.dart';

/// Fake API that returns seeded items so the screenshots show real content
/// without touching AWS Amplify / API Gateway.
class FakeItemsApi extends ItemsApi {
  static final _seed = <Item>[
    Item(id: 'a1', name: 'Industrial sensor kit', qty: 12),
    Item(id: 'a2', name: 'Edge gateway unit', qty: 4),
    Item(id: 'a3', name: 'Cognito-secured token', qty: 1),
    Item(id: 'a4', name: 'DynamoDB capacity block', qty: 25),
    Item(id: 'a5', name: 'Lambda warm pool', qty: 8),
    Item(id: 'a6', name: 'API Gateway stage', qty: 3),
  ];

  @override
  Future<List<Item>> list() async => _seed;

  @override
  Future<Item> get(String id) async =>
      _seed.firstWhere((e) => e.id == id, orElse: () => _seed.first);
}

/// Auth controller whose bootstrap does not touch Amplify.
class FakeAuthController extends AuthController {
  @override
  Future<void> bootstrap() async {}
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  Widget app(Widget home, {List<Override> overrides = const []}) => ProviderScope(
        overrides: overrides,
        child: MaterialApp(
            debugShowCheckedModeBanner: false, theme: buildAppTheme(), home: home),
      );

  final itemsOverride = <Override>[
    itemsApiProvider.overrideWithValue(FakeItemsApi()),
  ];

  testWidgets('capture sign-in screen', (tester) async {
    await tester.pumpWidget(app(const SignInPage()));
    await tester.pumpAndSettle();
    await shoot(tester, '01-sign-in');
  });

  testWidgets('capture items list', (tester) async {
    await tester.pumpWidget(app(const ItemsPage(), overrides: itemsOverride));
    await tester.pumpAndSettle();
    await shoot(tester, '02-items');
  });

  testWidgets('capture item detail', (tester) async {
    await tester.pumpWidget(app(const ItemDetailPage(id: 'a1'), overrides: itemsOverride));
    await tester.pumpAndSettle();
    await shoot(tester, '03-item-detail');
  });

  testWidgets('capture profile', (tester) async {
    await tester.pumpWidget(app(
      const ProfilePage(),
      overrides: [
        authControllerProvider.overrideWith(
          (ref) => FakeAuthController()
            ..state = const AuthState(
              signedIn: true,
              sub: 'us-east-1:9f2c',
              email: 'hau@example.com',
            ),
        ),
      ],
    ));
    await tester.pumpAndSettle();
    await shoot(tester, '04-profile');
  });
}
