import 'package:busnav/common/popups/snack_bar.dart';
import 'package:busnav/features/auth/screens/signup/verify_email_screen.dart';
import 'package:busnav/routes/routes_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static final AuthenticationRepository inctence = Get.find();
  // variables:
  final devicestorge = GetStorage();
  final _auth = FirebaseAuth.instance;

  // called in the main.dart after firebase initialization :
  @override
  void onReady() {
    authRedirect();
    super.onReady();
  }

  // recirect function
  void logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed(RoutesNames.login_screen);
    } catch (e) {
      if (kDebugMode) {
        print("auth_repo : $e");
      }
    }
  }

  void authRedirect() async {
    final user = _auth.currentUser;
    // check user
    if (user != null) {
      if (user.emailVerified) {
        Get.offAllNamed(RoutesNames.navigation_menu);
      } else {
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
      return;
    }
    //
    devicestorge.writeIfNull("firstTime", true);
    await Future.delayed(const Duration(milliseconds: 1000));
    !devicestorge.read("firstTime") ? await Get.offAllNamed(RoutesNames.login_screen) : await Get.offAllNamed(RoutesNames.onboarding_screen);
  }

  // -------------------------------- Email authentication [createUserWithEmailAndPassword] -------------------------------//
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        //  if email-already-in-use : -------------------------------------------------------
        // -----> stop the loader :
        if (Get.overlayContext != null) {
          Navigator.of(Get.overlayContext!).pop();
        }
        // -----> show warning SnackBar :
        MySnackBar.warningSnackBar(
          title: "unavailable E-mail",
          message: "account already exists for that email.",
          duration: const Duration(seconds: 3),
        );

        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  // ------------------------------------- [ verification email ] --------------------------
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // ------------------------------------- [ signin with email & password ] --------------------------
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }
      //------------------------------------------------------- show error :
      // stop the loader :
      if (Get.overlayContext != null) {
        Navigator.of(Get.overlayContext!).pop();
      }
      // show error message :
      MySnackBar.errorSnackBar(
        title: "Invalid email or password !",
        message: " Please verify your credentials and try again",
        duration: const Duration(seconds: 4),
      );
    }
    return null;
  }

  // =============================[Federated identity & social sign-in]===================================

  // ------------------------------------- [ signin with google :   ] -------------------------- :
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser =null;
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // Create a new credential
      final authCredential = GoogleAuthProvider.credential(accessToken: googleAuth?.idToken, idToken: googleAuth?.idToken);
      final credential = await FirebaseAuth.instance.signInWithCredential(authCredential);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) print('Wrong password provided for that user.');
      } else {
        if (kDebugMode) print('google signin Exeption : ${e.code}.');
      }

      //------------------------------------------------------- show error snack bar :
      // stop the loader :
      if (Get.overlayContext != null) {
        Navigator.of(Get.overlayContext!).pop();
      }
      // show error message :
      MySnackBar.errorSnackBar(title: "google sign in error!", message: " Please contact support !", duration: const Duration(seconds: 4));
    }
    return null;
  }

  // Send OTP to phone number
  Future<void> sendOtpToPhone({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          try {
            final userCredential = await _auth.signInWithCredential(credential);
            if (kDebugMode) {
              print('Auto verification completed: ${userCredential.user?.uid}');
            }
          } catch (e) {
            if (kDebugMode) {
              print('Auto verification failed: $e');
            }
          }
        },
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          if (kDebugMode) {
            print('Code auto retrieval timeout: $verificationId');
          }
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Send OTP error: $e');
      }
      rethrow;
    }
  }

  // Resend OTP
  Future<void> resendOtp({
    required String phoneNumber,
    int? resendToken,
    required Function(String, int?) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
          } catch (e) {
            if (kDebugMode) {
              print('Auto verification failed on resend: $e');
            }
          }
        },
        verificationFailed: onVerificationFailed,
        codeSent: onCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          if (kDebugMode) {
            print('Resend code auto retrieval timeout: $verificationId');
          }
        },
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Resend OTP error: $e');
      }
      rethrow;
    }
  }

  // Verify OTP and sign in
  Future<UserCredential?> verifyOtpAndSignIn(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('OTP verification error: ${e.code} - ${e.message}');
      }

      // Handle specific errors
      if (e.code == 'invalid-verification-code') {
        MySnackBar.errorSnackBar(
          title: "Invalid Code",
          message: "The verification code is incorrect. Please try again.",
          duration: const Duration(seconds: 3),
        );
      } else if (e.code == 'session-expired') {
        MySnackBar.errorSnackBar(
          title: "Session Expired",
          message: "The verification session has expired. Please request a new code.",
          duration: const Duration(seconds: 3),
        );
      }

      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Verify OTP unexpected error: $e');
      }
      rethrow;
    }
  }
}
