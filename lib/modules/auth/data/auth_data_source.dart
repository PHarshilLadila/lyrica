import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lyrica/core/providers/firebase_provider.dart';

class AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final Ref ref;

  AuthDataSource(this.firebaseAuth, this.ref);

  Future<Either<String, User>> register(
    String email,
    String password,
    String userName,
  ) async {
    try {
      final response = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(response.user!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to sign up");
    }
  }

  Future<Either<String, User>> login(String email, String password) async {
    try {
      final response = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(response.user!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to login");
    }
  }

  Future<Either<String, User>> googleAuthentication() async {
    try {
      final googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleuser = await googleSignIn.signIn();

      if (googleuser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleuser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final response = await firebaseAuth.signInWithCredential(credential);
        return Right(response.user!);
      } else {
        return Left("Failed to login with Google");
      }
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to login with Google");
    }
  }

  Future<Either<String, User>> signOut() async {
    try {
      await firebaseAuth.signOut();
      return Right(firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to sign out");
    }
  }

  Future<Either<String, User>> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return Right(firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to reset password");
    }
  }

  Future<Either<String, User>> updateUserName(String userName) async {
    try {
      await firebaseAuth.currentUser!.updateProfile(displayName: userName);
      return Right(firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to update user name");
    }
  }

  Future<Either<String, User>> deleteUser() async {
    try {
      await firebaseAuth.currentUser!.delete();
      return Right(firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? "Failed to delete user");
    }
  }
}

final authDataSourceProvider = Provider<AuthDataSource>(
  (ref) => AuthDataSource(ref.read(firebaseAuthProvider), ref),
);
