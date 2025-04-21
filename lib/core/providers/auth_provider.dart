import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyrica/repository/auth_repository.dart';

final authRepositoryprovider = Provider<AuthRepository>((ref) {
  return AuthRepository(FirebaseAuth.instance,FirebaseFirestore.instance);
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authRepositoryprovider).authStateChange;
});
