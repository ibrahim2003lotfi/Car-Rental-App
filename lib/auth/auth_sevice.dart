import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthSevice> authService = ValueNotifier(AuthSevice());

class AuthSevice {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAcount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserName({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> showUesrName({required String firstname}) async {
    await currentUser!.updateDisplayName(firstname);
    
  }
  
  
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  Future<void> updateEmailFromCurrentPassword({
  required String email,
  required String currentPassword,
  required String newEmail,
}) async {
  // Re-authenticate first
  final credential = EmailAuthProvider.credential(
    email: email,
    password: currentPassword,
  );
  await currentUser!.reauthenticateWithCredential(credential);
  await currentUser!.verifyBeforeUpdateEmail(newEmail);
  // Tip: Firebase may send a verification link to confirm the new email.
}

Future<void> sendEmailVerification() async {
  try {
    await currentUser!.sendEmailVerification();
    debugPrint('Verification email sent to ${currentUser!.email}');
  } catch (e) {
    debugPrint('Error sending verification email: $e');
    rethrow; // This will let you see the error in your UI
  }
}
}
