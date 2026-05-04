import 'package:busnav/common/popups/loader.dart';
import 'package:busnav/common/popups/snack_bar.dart';
import 'package:busnav/data/repositories/authentication_repo.dart';
import 'package:busnav/data/repositories/user_repo.dart';
import 'package:busnav/features/auth/screens/otp/otp_verification_screen.dart';
import 'package:busnav/features/personalization/models/user_model.dart';
import 'package:busnav/services/network_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class OtpLoginController extends GetxController {
  static final OtpLoginController instance = Get.find();

  // Variables
  final phoneNumber = TextEditingController();
  final otpCode = TextEditingController();
  GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  // States
  Rx<bool> isCodeSent = false.obs;
  Rx<int> resendTimer = 0.obs;
  Timer? _timer;
  String? verificationId;
  int? resendToken;

  @override
  void onClose() {
    _timer?.cancel();
    phoneNumber.dispose();
    otpCode.dispose();
    super.onClose();
  }

  // Send OTP to phone number
  Future<void> sendOtp() async {
    try {
      // Start loading
      Loader.loader();

      // Check internet connectivity
      final connected = await NetworkController.instance.isConected();
      if (!connected) return;

      // Form validation
      if (!phoneFormKey.currentState!.validate()) {
        if (Get.overlayContext != null) {
          Navigator.of(Get.overlayContext!).pop();
        }
        return;
      }

      // Format phone number (ensure it starts with country code)
      String formattedPhoneNumber = _formatPhoneNumber(phoneNumber.text.trim());

      await AuthenticationRepository.inctence.sendOtpToPhone(
        phoneNumber: formattedPhoneNumber,
        onCodeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          this.resendToken = resendToken;
          isCodeSent.value = true;
          _startResendTimer();

          // Stop loader
          if (Get.overlayContext != null) {
            Navigator.of(Get.overlayContext!).pop();
          }

          // Navigate to OTP verification screen
          Get.to(() => OtpVerificationScreen(phoneNumber: formattedPhoneNumber));

          MySnackBar.successSnackBar(
            title: "OTP Sent",
            message: "Verification code sent to $formattedPhoneNumber",
            duration: const Duration(seconds: 3),
          );
        },
        onVerificationFailed: (FirebaseAuthException e) {
          if (Get.overlayContext != null) {
            Navigator.of(Get.overlayContext!).pop();
          }

          MySnackBar.errorSnackBar(title: "Verification Failed", message: _getFirebaseErrorMessage(e), duration: const Duration(seconds: 4));
        },
      );
    } catch (e) {
      if (Get.overlayContext != null) {
        Navigator.of(Get.overlayContext!).pop();
      }

      if (kDebugMode) {
        print('Send OTP Error: $e');
      }

      MySnackBar.errorSnackBar(title: "Error", message: "Failed to send OTP. Please try again.", duration: const Duration(seconds: 3));
    }
  }

  // Verify OTP and sign in
  Future<void> verifyOtpAndSignIn() async {
    try {
      // Start loading
      Loader.loader();

      // Check internet connectivity
      final connected = await NetworkController.instance.isConected();
      if (!connected) return;

      // Form validation
      if (!otpFormKey.currentState!.validate()) {
        if (Get.overlayContext != null) {
          Navigator.of(Get.overlayContext!).pop();
        }
        return;
      }

      if (verificationId == null) {
        if (Get.overlayContext != null) {
          Navigator.of(Get.overlayContext!).pop();
        }
        MySnackBar.errorSnackBar(title: "Error", message: "Please request OTP first", duration: const Duration(seconds: 3));
        return;
      }

      final UserCredential? userCredential = await AuthenticationRepository.inctence.verifyOtpAndSignIn(verificationId!, otpCode.text.trim());

      if (userCredential != null) {
        // Check if this is a new user
        if (userCredential.additionalUserInfo?.isNewUser == true) {
          // Create user model for new user
          UserModel newUser = UserModel(
            userId: userCredential.user!.uid,
            firstName: "",
            lastName: "",
            username: "",
            phoneNumber: userCredential.user!.phoneNumber ?? phoneNumber.text.trim(),
            email: "",
            password: "",
          );

          // Save user to Firestore
          final UserRepository userRepository = Get.put(UserRepository());
          await userRepository.saveUser(newUser);
        }

        if (Get.overlayContext != null) {
          Navigator.of(Get.overlayContext!).pop();
        }

        MySnackBar.successSnackBar(title: "Success", message: "Phone number verified successfully", duration: const Duration(seconds: 2));

        // Redirect to main app
        AuthenticationRepository.inctence.authRedirect();
      }
    } catch (e) {
      if (Get.overlayContext != null) {
        Navigator.of(Get.overlayContext!).pop();
      }

      if (kDebugMode) {
        print('Verify OTP Error: $e');
      }

      MySnackBar.errorSnackBar(title: "Verification Failed", message: "Invalid OTP. Please try again.", duration: const Duration(seconds: 3));
    }
  }

  // Resend OTP
  Future<void> resendOtp() async {
    if (resendTimer.value > 0) return;

    try {
      Loader.loader();

      String formattedPhoneNumber = _formatPhoneNumber(phoneNumber.text.trim());

      await AuthenticationRepository.inctence.resendOtp(
        phoneNumber: formattedPhoneNumber,
        resendToken: resendToken,
        onCodeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          this.resendToken = resendToken;
          _startResendTimer();

          if (Get.overlayContext != null) {
            Navigator.of(Get.overlayContext!).pop();
          }

          MySnackBar.successSnackBar(
            title: "OTP Resent",
            message: "New verification code sent to $formattedPhoneNumber",
            duration: const Duration(seconds: 3),
          );
        },
        onVerificationFailed: (FirebaseAuthException e) {
          if (Get.overlayContext != null) {
            Navigator.of(Get.overlayContext!).pop();
          }

          MySnackBar.errorSnackBar(title: "Resend Failed", message: _getFirebaseErrorMessage(e), duration: const Duration(seconds: 4));
        },
      );
    } catch (e) {
      if (Get.overlayContext != null) {
        Navigator.of(Get.overlayContext!).pop();
      }

      if (kDebugMode) {
        print('Resend OTP Error: $e');
      }
    }
  }

  // Start resend timer
  void _startResendTimer() {
    resendTimer.value = 60; // 60 seconds timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  // Format phone number to include country code
  String _formatPhoneNumber(String phoneNumber) {
    // Remove any spaces, dashes, or other formatting
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // If it doesn't start with +, add country code (assuming +1 for US/CA, modify as needed)
    if (!cleaned.startsWith('+')) {
      // You can modify this logic based on your app's target countries
      cleaned = '+1$cleaned';
    }

    return cleaned;
  }

  // Get user-friendly error messages
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'The phone number is not valid.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'invalid-verification-code':
        return 'The verification code is invalid.';
      case 'session-expired':
        return 'The verification session has expired. Please request a new code.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // Reset controller state
  void resetState() {
    isCodeSent.value = false;
    resendTimer.value = 0;
    _timer?.cancel();
    verificationId = null;
    resendToken = null;
    phoneNumber.clear();
    otpCode.clear();
  }
}
