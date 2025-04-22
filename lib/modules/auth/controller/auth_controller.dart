import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lyrica/core/providers/provider.dart';
import 'package:lyrica/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final Ref _ref;

  AuthController(this._ref);

  FirebaseAuth get _auth => _ref.read(firebaseAuthProvider);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  // final QuerySnapshot<Map<String, dynamic>> _userData =
  //     {} as QuerySnapshot<Map<String, dynamic>>;
  // QuerySnapshot<Map<String, dynamic>> get userData => _userData;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential?> register(
    String userName,
    String email,
    String number,
    String password,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final appUser = firestore.collection("users");
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await preferences.setString("userUID", credential.user!.uid);

      await appUser.doc(credential.user!.uid).set({
        "username": userName,
        "mobile": number,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final result = userCredential.user;
      await preferences.setString("userUID", result!.uid);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      await preferences.setString("userUID", userCredential.user!.uid);
      return userCredential.user;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      return null;
    }
  }

  Future<UserModel?> getUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      final docSnapshot =
          await firestore.collection("users").doc(currentUser.uid).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          return UserModel.fromMap(data);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching user: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
