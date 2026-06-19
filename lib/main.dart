import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';

import 'core/amplify_config.dart';
import 'core/router.dart';
import 'core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const ProviderScope(child: App()));
}

Future<void> _configureAmplify() async {
  try {
    await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyAPI()]);
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
    // hot restart
  }
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'AWS Serverless POC',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
