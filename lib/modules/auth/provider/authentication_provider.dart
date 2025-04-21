import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyrica/modules/auth/data/auth_data_source.dart';
import 'package:lyrica/modules/auth/provider/states/authentication_state.dart';

class AuthNotifier extends StateNotifier<AuthenticationState> {
  AuthNotifier(this.dataSource) : super(const AuthenticationState.initial());

  final AuthDataSource dataSource;

  Future<void> login({required String email, required String password}) async {
    state = const AuthenticationState.loading();
    final response = await dataSource.login(email, password);
    state = response.fold(
      (error) => AuthenticationState.unauthenticated(message: error),
      (response) => AuthenticationState.authenticated(user: response),
    );
  }

  Future<void> signup({
    required String email,
    required String password,
    required String userName,
  }) async {
    state = const AuthenticationState.loading();
    final response = await dataSource.register(email, password, userName);
    state = response.fold(
      (error) => AuthenticationState.unauthenticated(message: error),
      (response) => AuthenticationState.authenticated(user: response),
    );
  }

  Future<void> continueWithGoogle() async {
    state = const AuthenticationState.loading();
    final response = await dataSource.googleAuthentication();
    state = response.fold(
      (error) => AuthenticationState.unauthenticated(message: error),
      (response) => AuthenticationState.authenticated(user: response),
    );
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthenticationState>(
      (ref) => AuthNotifier(ref.read(authDataSourceProvider)),
    );
