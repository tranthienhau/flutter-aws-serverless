import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool signedIn;
  final String? sub;
  final String? email;
  const AuthState({required this.signedIn, this.sub, this.email});
  AuthState copyWith({bool? signedIn, String? sub, String? email}) =>
      AuthState(signedIn: signedIn ?? this.signedIn, sub: sub ?? this.sub, email: email ?? this.email);
  static const initial = AuthState(signedIn: false);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState.initial) { bootstrap(); }

  @protected
  Future<void> bootstrap() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      state = state.copyWith(signedIn: session.isSignedIn);
    } catch (_) {}
  }

  Future<void> signIn(String email, String password) async {
    final r = await Amplify.Auth.signIn(username: email, password: password);
    state = state.copyWith(signedIn: r.isSignedIn, email: email);
  }

  Future<void> signUp(String email, String password) async {
    await Amplify.Auth.signUp(
      username: email, password: password,
      options: SignUpOptions(userAttributes: {AuthUserAttributeKey.email: email}),
    );
  }

  Future<void> confirm(String email, String code) async {
    await Amplify.Auth.confirmSignUp(username: email, confirmationCode: code);
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
    state = AuthState.initial;
  }

  Future<String?> idToken() async {
    final s = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
    return s.userPoolTokensResult.value.idToken.raw;
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((_) => AuthController());
