// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:lyrica/core/providers/provider.dart';
// import 'package:lyrica/model/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthController {
//   final Ref _ref;

//   AuthController(this._ref);

//   FirebaseAuth get _auth => _ref.read(firebaseAuthProvider);
//   FirebaseFirestore get _firestore => FirebaseFirestore.instance;

//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   Future<UserCredential?> register(
//     String userName,
//     String email,
//     String number,
//     String password,
//   ) async {
//     try {
//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final uid = credential.user!.uid;

//       final user = UserModel(
//         uid: uid,
//         username: userName,
//         email: email,
//         mobile: number,
//         image: "",
//         createdAt: DateTime.now(),
//       );

//       await _saveUserToFirestore(user);
//       await _saveUserToLocal(user);

//       return credential;
//     } on FirebaseAuthException catch (e) {
//       debugPrint("Register error: ${e.message}");
//       return null;
//     }
//   }

//   Future<bool> saveUserToFirestore(UserModel user) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection("users")
//           .doc(user.uid)
//           .set(user.toMap(), SetOptions(merge: true));
//       return true;
//     } catch (e) {
//       debugPrint("Error saving user: $e");
//       return false;
//     }
//   }

//   Future<bool> saveUserToLocal(UserModel user) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString("userUID", user.uid);
//       await prefs.setString("userName", user.username);
//       return true;
//     } catch (e) {
//       debugPrint("Error saving user locally: $e");
//       return false;
//     }
//   }

//   Future<User?> login(String email, String password) async {
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final user = await getUserFromFirestore(userCredential.user!.uid);
//       if (user != null) {
//         await _saveUserToLocal(user);
//       }

//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       debugPrint("Login error: ${e.message}");
//       return null;
//     }
//   }

//   Future<User?> signInWithGoogle() async {
//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return null;

//       final googleAuth = await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await _auth.signInWithCredential(credential);
//       final firebaseUser = userCredential.user!;
//       final uid = firebaseUser.uid;

//       final userModel = UserModel(
//         uid: uid,
//         username: firebaseUser.displayName ?? "N/A",
//         email: firebaseUser.email ?? "N/A",
//         mobile: "",
//         image: firebaseUser.photoURL ?? "",
//         createdAt: DateTime.now(),
//       );

//       await _saveUserToFirestore(userModel);
//       await _saveUserToLocal(userModel);

//       return firebaseUser;
//     } catch (e) {
//       debugPrint("Google sign-in error: $e");
//       return null;
//     }
//   }

//   Future<User?> facebookLogin() async {
//     try {
//       final result = await FacebookAuth.instance.login(
//         permissions: [
//           'public_profile',
//           'email',
//           'user_birthday',
//           'user_gender',
//         ],
//       );

//       if (result.status == LoginStatus.success) {
//         final accessToken = result.accessToken;

//         final userData = await FacebookAuth.instance.getUserData(
//           fields:
//               "id,name,email,first_name,last_name,picture.width(200),birthday,gender,link,locale,timezone,updated_time,verified",
//         );

//         final credential = FacebookAuthProvider.credential(accessToken!.token);
//         final userCredential = await FirebaseAuth.instance.signInWithCredential(
//           credential,
//         );

//         final firebaseUser = userCredential.user!;
//         final uid = firebaseUser.uid;

//         final userModel = UserModel(
//           uid: uid,
//           username: userData['name'] ?? "N/A",
//           email: userData['email'] ?? "N/A",
//           mobile: "N/A",
//           image: userData['picture']['data']['url'] ?? "",
//           createdAt: DateTime.now(),
//         );

//         await _saveUserToFirestore(userModel);
//         await _saveUserToLocal(userModel);

//         return firebaseUser;
//       } else {
//         debugPrint("Facebook login failed: ${result.status}");
//         return null;
//       }
//     } catch (e) {
//       debugPrint("Facebook login error: $e");
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//     await GoogleSignIn().signOut();
//     await FacebookAuth.instance.logOut();

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove("notifications_enabled");
//     await prefs.clear();

//     debugPrint("User signed out successfully");
//   }

//   Future<UserModel?> getUser() async {
//     try {
//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return null;

//       return await getUserFromFirestore(currentUser.uid);
//     } catch (e) {
//       debugPrint("Get user error: $e");
//       return null;
//     }
//   }

//   Future<UserModel?> getUserFromFirestore(String uid) async {
//     try {
//       final snapshot = await _firestore.collection("users").doc(uid).get();
//       if (snapshot.exists) {
//         return UserModel.fromMap(snapshot.data()!);
//       }
//       return null;
//     } catch (e) {
//       debugPrint("Fetch Firestore user error: $e");
//       return null;
//     }
//   }

//   Future<void> _saveUserToFirestore(UserModel user) async {
//     await _firestore.collection("users").doc(user.uid).set(user.toMap());
//   }

//   Future<void> _saveUserToLocal(UserModel user) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString("userUID", user.uid);
//     await prefs.setString("userName", user.username);
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> register(
    String userName,
    String email,
    String number,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      final user = UserModel(
        uid: uid,
        username: userName,
        email: email,
        mobile: number,
        image: "",
        createdAt: DateTime.now(),
      );

      await saveUserToFirestore(user);
      await saveUserToLocal(user);
      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Register error: ${e.message}");
      return null;
    }
  }

  Future<bool> saveUserToFirestore(UserModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(user.toMap(), SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint("Error saving user to Firestore: $e");
      return false;
    }
  }

  Future<bool> saveUserToLocal(UserModel user) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("userUID", user.uid);
      await prefs.setString("userName", user.username);
      return true;
    } catch (e) {
      debugPrint("Error saving user locally: $e");
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Always get the latest user data from Firestore
      final user = await getUserFromFirestore(userCredential.user!.uid);
      if (user != null) {
        await saveUserToLocal(user);
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Login error: ${e.message}");
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      final userModel = UserModel(
        uid: firebaseUser.uid,
        username: firebaseUser.displayName ?? "N/A",
        email: firebaseUser.email ?? "N/A",
        mobile: "",
        image: firebaseUser.photoURL ?? "",
        createdAt: DateTime.now(),
      );

      await saveUserToFirestore(userModel);
      await saveUserToLocal(userModel);

      return firebaseUser;
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      return null;
    }
  }

  Future<User?> facebookLogin() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: [
          'public_profile',
          'email',
          'user_birthday',
          'user_gender',
        ],
      );

      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;

        final userData = await FacebookAuth.instance.getUserData(
          fields:
              "id,name,email,first_name,last_name,picture.width(200),birthday,gender,link,locale,timezone,updated_time,verified",
        );

        final credential = FacebookAuthProvider.credential(accessToken!.token);
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );

        final firebaseUser = userCredential.user!;

        final userModel = UserModel(
          uid: firebaseUser.uid,
          username: userData['name'] ?? "N/A",
          email: userData['email'] ?? "N/A",
          mobile: "N/A",
          image: userData['picture']['data']['url'] ?? "",
          createdAt: DateTime.now(),
        );

        await saveUserToFirestore(userModel);
        await saveUserToLocal(userModel);

        return firebaseUser;
      } else {
        debugPrint("Facebook login failed: ${result.status}");
        return null;
      }
    } catch (e) {
      debugPrint("Facebook login error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("notifications_enabled");
    await prefs.clear();

    debugPrint("User signed out successfully");
  }

  Future<UserModel?> getUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return null;

      return await getUserFromFirestore(currentUser.uid);
    } catch (e) {
      debugPrint("Get user error: $e");
      return null;
    }
  }

  Future<UserModel?> getUserFromFirestore(String uid) async {
    try {
      final snapshot = await _firestore.collection("users").doc(uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        return UserModel.fromMap(snapshot.data()!);
      }
      return null;
    } catch (e) {
      debugPrint("Fetch Firestore user error: $e");
      return null;
    }
  }
}
