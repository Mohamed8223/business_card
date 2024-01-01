import 'package:clinigram_app/features/auth/auth.dart';
import 'package:clinigram_app/features/doctors/doctors.dart';
import 'package:clinigram_app/features/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

import '../../../core/core.dart';
import '../../admin_manage/admin_manage.dart';
import '../../notifications/notifications.dart';

class AuthNotifier extends StateNotifier<PhoneVerifyStatusModel> {
  AuthNotifier(this._ref) : super(PhoneVerifyStatusModel.init());
  final Ref _ref;
  final signUpformkey = GlobalKey<FormState>();

  Future phoneAuthintication(String phoneNumber) async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();

      if (kIsWeb) {
        printDebug("is web. singInWithPhoneNumber started with $phoneNumber");

        // Handle web-specific authentication
        FirebaseAuth auth = FirebaseAuth.instance;

        var fullPhoneNumber = "+972 $phoneNumber";

        ConfirmationResult confirmationResult =
            await auth.signInWithPhoneNumber(fullPhoneNumber);

        printDebug("confirmationResult: $confirmationResult");

        state = PhoneVerifyStatusModel.codeSent(
            receivedID: confirmationResult.verificationId,
            phone: fullPhoneNumber);

        printDebug("state: $state");
        // From here, you can extract user information or any other relevant data.
      } else {
        // Handle mobile-specific authentication
        final receivedID =
            await _ref.read(authRepoProvider).verifyPhoneNumber(phoneNumber);
        state = PhoneVerifyStatusModel.codeSent(
            receivedID: receivedID, phone: phoneNumber);
      }
    } catch (e) {
      state = PhoneVerifyStatusModel.error(message: e.toString());
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }

  void signInWithFacebook() async {
    _ref.read(requestResponseProvider.notifier).state =
        RequestResponseModel.loading();
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    if (loginResult.accessToken != null) {
      // Create a credential from the access token
      final facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.token,
      );
      try {
        final credential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        final preRegisterdDoctor = await _ref
            .read(profileRepoProvider)
            .getUserPhoneOrEmail(null, credential.user!.email);
        if (preRegisterdDoctor != null) {
          await _ref.read(profileRepoProvider).createUser(
              preRegisterdDoctor.copyWith(id: credential.user!.uid),
              credential);
          await _ref
              .read(doctorsRepoProvider)
              .deletePreRegisterDoctor(preRegisterdDoctor.id);
          final userData = await _ref
              .read(profileRepoProvider)
              .getUserById(credential.user!.uid);
          await _storeUserFCMToken(userData!);
          state = PhoneVerifyStatusModel.codeVerified(
            isProfileCompleted: true,
          );
        } else {
          final userData = await _ref
              .read(profileRepoProvider)
              .getUserById(credential.user!.uid);
          if (userData != null) {
            _ref.read(currentUserProfileProvider.notifier).state = userData;
            await _storeUserFCMToken(userData);
            state = PhoneVerifyStatusModel.codeVerified(
              isProfileCompleted: true,
            );
          } else {
            await _ref.read(categoriesProvider.notifier).getCategories();
            await _ref.read(citiesProvider.notifier).getCities();
            _ref.read(currentUserProfileProvider.notifier).state =
                UserModel.init().copyWith(email: credential.user!.email!);
            _ref
                .read(tempUserCredentialProvider.notifier)
                .update((state) => credential);
            state = PhoneVerifyStatusModel.codeVerified(
              isProfileCompleted: false,
            );
          }
        }
      } catch (e) {
        state = PhoneVerifyStatusModel.error(message: e.toString());
        FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      } finally {
        _ref.read(requestResponseProvider.notifier).state =
            RequestResponseModel.loading(loading: false);
      }
    }
  }

  void signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final oAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      final credential =
          await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
      final preRegisterdDoctor = await _ref
          .read(profileRepoProvider)
          .getUserPhoneOrEmail(null, credential.user!.email);
      if (preRegisterdDoctor != null) {
        await _ref.read(profileRepoProvider).createUser(
            preRegisterdDoctor.copyWith(id: credential.user!.uid), credential);
        await _ref
            .read(doctorsRepoProvider)
            .deletePreRegisterDoctor(preRegisterdDoctor.id);
        final userData = await _ref
            .read(profileRepoProvider)
            .getUserById(credential.user!.uid);
        await _storeUserFCMToken(userData!);
        state = PhoneVerifyStatusModel.codeVerified(
          isProfileCompleted: true,
        );
      } else {
        final userData = await _ref
            .read(profileRepoProvider)
            .getUserById(credential.user!.uid);
        if (userData != null) {
          _ref.read(currentUserProfileProvider.notifier).state = userData;
          await _storeUserFCMToken(userData);
          state = PhoneVerifyStatusModel.codeVerified(
            isProfileCompleted: true,
          );
        } else {
          await _ref.read(categoriesProvider.notifier).getCategories();
          await _ref.read(citiesProvider.notifier).getCities();
          _ref.read(currentUserProfileProvider.notifier).state =
              UserModel.init().copyWith(email: credential.user!.email!);
          _ref
              .read(tempUserCredentialProvider.notifier)
              .update((state) => credential);
          state = PhoneVerifyStatusModel.codeVerified(
            isProfileCompleted: false,
          );
        }
      }
    } catch (e) {
      state = PhoneVerifyStatusModel.error(message: e.toString());
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }

  Future otpVerification(String phone, String code, String receivedID) async {
    printDebug(
        "otpVerification started with code: $code, receivedID: $receivedID");

    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      final credential =
          await _ref.read(authRepoProvider).otpVerification(code, receivedID);
      final preRegisterdDoctor =
          await _ref.read(profileRepoProvider).getUserPhoneOrEmail(phone, null);
      print('=========================');
      if (preRegisterdDoctor != null) {
        await _ref.read(profileRepoProvider).createUser(
            preRegisterdDoctor.copyWith(id: credential.user!.uid), credential);
        await _ref
            .read(doctorsRepoProvider)
            .deletePreRegisterDoctor(preRegisterdDoctor.id);
        final userData = await _ref
            .read(profileRepoProvider)
            .getUserById(credential.user!.uid);
        await _storeUserFCMToken(userData!);
        state = PhoneVerifyStatusModel.codeVerified(
          isProfileCompleted: true,
        );
      }
      else {
        final userData = await _ref
            .read(profileRepoProvider)
            .getUserById(credential.user!.uid);
        if (userData != null) {
          _ref.read(currentUserProfileProvider.notifier).state = userData;
          await _storeUserFCMToken(userData);
          state = PhoneVerifyStatusModel.codeVerified(
            isProfileCompleted: true,
          );
        }
        else {
          await _ref.read(categoriesProvider.notifier).getCategories();
          await _ref.read(citiesProvider.notifier).getCities();
          _ref.read(currentUserProfileProvider.notifier).state =
              UserModel.init().copyWith(phone: phone);
          _ref
              .read(tempUserCredentialProvider.notifier)
              .update((state) => credential);
          state = PhoneVerifyStatusModel.codeVerified(
            isProfileCompleted: false,
          );
        }
      }
    } catch (e) {
      print(e);
      state = PhoneVerifyStatusModel.error(message: e.toString());
      // FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    } finally {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading(loading: false);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final data = await _ref.read(authRepoProvider).getCurrentloggedUser();

    if (data != null) {
      _ref.read(currentUserProfileProvider.notifier).state = data;
      return data;
    }
    return null;
  }

  Future<void> logout() async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      await _ref.read(authRepoProvider).userLogout();
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error();
    }
  }

  Future<void> deleteUser() async {
    try {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      await _ref.read(authRepoProvider).deleteUserAccount();
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error();
    }
  }

  Future<void> registerUser(UserModel userModel) async {
    try {
      print('--------------------------------------------------------------------');

    _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.loading();
      final userCredential = _ref.read(tempUserCredentialProvider)!;
      await _ref
          .read(profileRepoProvider)
          .createUser(userModel, userCredential);
      final userData = await _ref
          .read(profileRepoProvider)
          .getUserById(userCredential.user!.uid);
      _ref.read(currentUserProfileProvider.notifier).state = userData!;
      await _storeUserFCMToken(userData);
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.sucess();
    } catch (e) {
      _ref.read(requestResponseProvider.notifier).state =
          RequestResponseModel.error(message: e.toString());
    }
  }

  Future<void> _storeUserFCMToken(UserModel userData) async {
    // Using _ref.read for FutureProvider gives AsyncValue<String> which can be in data/loading/error state.
    final asyncValue = _ref.read(fcmTokenProvider);

    // Check if data is available
    if (asyncValue is AsyncData<String>) {
      final fcmToken = asyncValue.value;

      // Your logic to update user profile.
      await _ref
          .read(profileRepoProvider)
          .updateProfile(userData.copyWith(fcmToken: fcmToken));
    } else if (asyncValue is AsyncError) {
      // Handle error accordingly.
      printDebug('Error fetching FCM Token: ${asyncValue.error}');
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, PhoneVerifyStatusModel>((ref) {
  return AuthNotifier(ref);
});
final checkCurrentUserProvider = FutureProvider<UserModel?>((ref) async {
  return await ref.read(authProvider.notifier).getCurrentUser();
});
