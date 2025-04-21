import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyrica/core/providers/auth_provider.dart';
import 'package:lyrica/modules/auth/vm/login_state.dart';

class LoginController extends StateNotifier<LoginState> {
  final Ref ref;
  LoginController(this.ref) : super(LoginStateInitial());

  Future<bool> login(String email, String password) async {
    state = const LoginStateLoading();
    try {
      await ref
          .read(authRepositoryprovider)
          .signInWithEmailAndPassword(email, password);

      state = const LoginStateSuccess();
      return true;
    } catch (e) {
      debugPrint(e.toString());

      state = LoginStateError(e.toString());
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = const LoginStateLoading();
    try {
      await ref
          .read(authRepositoryprovider)
          .createAccount(name, email, password);

      state = const LoginStateSuccess();
      return true;
    } catch (e) {
      debugPrint(e.toString());

      state = LoginStateError(e.toString());
      return false;
    }
  }

  Future<bool> googleAuth() async {
    state = const LoginStateLoading();
    try {
      await ref.read(authRepositoryprovider).signInWithGoogle();

      state = LoginStateSuccess();
      return true;
    } catch (e) {
      state = LoginStateError(e.toString());
      debugPrint(e.toString());
      return false;
    }
  }

  void logout() async {
    state = const LoginStateLoading();
    try {
      await ref.read(authRepositoryprovider).signOut();
      state = const LoginStateSuccess();
    } catch (e) {
      state = LoginStateError(e.toString());
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
      return LoginController(ref);
    });
