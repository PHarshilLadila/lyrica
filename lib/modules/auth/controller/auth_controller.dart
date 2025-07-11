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

//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<UserCredential?> register(
//     String userName,
//     String email,
//     String number,
//     String password,
//   ) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     final appUser = firestore.collection("users");
//     try {
//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       await preferences.setString("userUID", credential.user!.uid);
//       await preferences.setString(
//         "userName",
//         credential.user!.displayName ?? "N/A",
//       );

//       await appUser.doc(credential.user!.uid).set({
//         "username": userName,
//         "mobile": number,
//         "email": email,
//         "createdAt": FieldValue.serverTimestamp(),
//       });

//       return credential;
//     } on FirebaseAuthException catch (e) {
//       debugPrint(e.toString());
//       return null;
//     }
//   }

//   Future<User?> login(String email, String password) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final result = userCredential.user;
//       await preferences.setString("userUID", result?.uid ?? "N/A");
//       await preferences.setString("userName", result?.displayName ?? "N/A");

//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       debugPrint('Login error: ${e.message}');
//       return null;
//     } catch (e) {
//       debugPrint('Unexpected login error: $e');
//       return null;
//     }
//   }

//   Future<User?> signInWithGoogle() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     try {
//       final googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) return null;

//       final googleAuth = await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential = await _auth.signInWithCredential(credential);
//       await preferences.setString("userUID", userCredential.user!.uid);
//       await preferences.setString(
//         "userName",
//         userCredential.user!.displayName ?? "N/A",
//       );
//       return userCredential.user;
//     } catch (e) {
//       debugPrint('Google sign-in error: $e');
//       return null;
//     }
//   }

//   Future<UserModel?> getUser() async {
//     try {
//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return null;

//       final docSnapshot =
//           await firestore.collection("users").doc(currentUser.uid).get();

//       if (docSnapshot.exists) {
//         final data = docSnapshot.data();
//         if (data != null) {
//           return UserModel.fromMap(data);
//         }
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error fetching user: $e');
//       return null;
//     }
//   }

//   Future<bool> facebookLogin() async {
//     debugPrint('Facebook Login ======');
//     final LoginResult result = await FacebookAuth.instance.login(
//       permissions: ["public_profile", "email"],
//     ); // by default we request the email and the public profile
//     if (result.status == LoginStatus.success) {
//       debugPrint('TOken -->  ${result.accessToken.toString()}');
//       // get the user data
//       // by default we get the userId, email,name and picture
//       var userData = await FacebookAuth.instance.getUserData();
//       // final userData = await FacebookAuth.instance.getUserData(fields: "email");
//       debugPrint('User Profile --->}');
//       debugPrint('User Profile ---> ${userData.toString()}');
//       debugPrint('User Profile ---> ${userData['email']}');
//       debugPrint('User Profile ---> ${userData.length}');

//       userData = userData;
//       debugPrint("User DAta ---> ${userData.toString()}");
//       return true;
//     } else {
//       debugPrint("${result.status}");
//       debugPrint(result.message);
//       return false;
//     }
//   }

//   // Future<UserModel?> getUser() async {
//   //   try {
//   //     final currentUser = _auth.currentUser;
//   //     if (currentUser == null) return null;

//   //     final docSnapshot =
//   //         await firestore.collection("users").doc(currentUser.uid).get();

//   //     if (docSnapshot.exists) {
//   //       final data = docSnapshot.data();
//   //       if (data != null) {
//   //         return UserModel.fromMap(data);
//   //       }
//   //     }
//   //     return null;
//   //   } catch (e) {
//   //     debugPrint('Error fetching user: $e');
//   //     return null;
//   //   }
//   // }

//   Future<void> signOut() async {
//     await _auth.signOut();
//     await GoogleSignIn().signOut();
//     await FacebookAuth.instance.logOut();
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await preferences.remove("userUID");
//     await preferences.remove("userName");
//     await preferences.clear();
//     debugPrint("User signed out successfully");
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

      await _saveUserToFirestore(user);
      await _saveUserToLocal(user);

      return credential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Register error: ${e.message}");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = await getUserFromFirestore(userCredential.user!.uid);
      if (user != null) {
        await _saveUserToLocal(user);
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
      final uid = firebaseUser.uid;

      final userModel = UserModel(
        uid: uid,
        username: firebaseUser.displayName ?? "N/A",
        email: firebaseUser.email ?? "N/A",
        mobile: "",
        image: firebaseUser.photoURL ?? "",
        createdAt: DateTime.now(),
      );

      await _saveUserToFirestore(userModel);
      await _saveUserToLocal(userModel);

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
        final uid = firebaseUser.uid;

        final userModel = UserModel(
          uid: uid,
          username: userData['name'] ?? "N/A",
          email: userData['email'] ?? "N/A", // Check availability
          mobile: "N/A", // Not provided by Facebook
          image: userData['picture']['data']['url'] ?? "",
          createdAt: DateTime.now(),
        );

        await _saveUserToFirestore(userModel);
        await _saveUserToLocal(userModel);

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
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      }
      return null;
    } catch (e) {
      debugPrint("Fetch Firestore user error: $e");
      return null;
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore.collection("users").doc(user.uid).set(user.toMap());
  }

  Future<void> _saveUserToLocal(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userUID", user.uid);
    await prefs.setString("userName", user.username);
  }
}
