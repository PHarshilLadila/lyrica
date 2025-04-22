 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lyrica/model/user_model.dart';
import 'package:lyrica/modules/auth/controller/auth_controller.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authControllerProvider = Provider((ref) {
  return AuthController(ref);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authControllerProvider).authStateChanges;
});

final userModelProvider = FutureProvider<UserModel?>((ref) async {
  final authController = ref.read(authControllerProvider);
  return await authController.getUser();
});
