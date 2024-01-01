import 'dart:async' show Completer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../notifications/notifications.dart';
import '../../../profile/profile.dart';

class AuthRepo {
  AuthRepo(this._ref) {
    // Initialize notifications
    _ref.read(notificationsRepoProvider);
    _ref.read(fcmTokenProvider);
  }
  final Ref _ref;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future userLogin(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<String> verifyPhoneNumber(
    String phoneNumber,
  ) async {
    Completer<String> completer = Completer<String>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+972$phoneNumber',
      verificationCompleted: (phoneAuthCredential) {
        completer.complete(phoneAuthCredential.verificationId!);
      },
      verificationFailed: (error) {
        // throw error;
      },
      codeSent: (verificationId, forceResendingToken) {
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    return completer.future;
  }

  Future<UserCredential> otpVerification(
    String code,
    String receivedID,
  ) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: code,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential;
  }

  Future deleteUserAccount() async {
    final user = _firebaseAuth.currentUser;
    await user!.delete();
  }

  Future userLogout() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> getCurrentloggedUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await _ref.read(profileRepoProvider).getUserById(user.uid);
    }
    return null;
  }
}

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo(ref);
});
