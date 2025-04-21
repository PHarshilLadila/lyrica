import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  const AuthRepository(this._auth, this._firestore);

  Stream<User?> get authStateChange => _auth.idTokenChanges();

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw Exception("User not found");
      } else if (e.code == "wrong-password") {
        throw Exception('Wrong Password');
      } else if (e.code == "invalid-credential") {
        throw Exception("invalid credential");
      } else if (e.code == "invalid-email") {
        throw Exception("Your email address appears to be malformed.");
      } else {
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }

  Future<User?> createAccount(
    String userName,
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection("users").doc(result.user?.uid).set({
        "uid": result.user?.uid,
        "username": userName,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return result.user;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (e.code == "user-not-found") {
        throw Exception("User not found");
      } else if (e.code == "wrong-password") {
        throw Exception('Wrong Password');
      } else if (e.code == "invalid-credential") {
        throw Exception("invalid credential");
      } else if (e.code == "invalid-email") {
        throw Exception("Your email address appears to be malformed.");
      } else {
        throw Exception("Something went wrong. Please try again.");
      }
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
