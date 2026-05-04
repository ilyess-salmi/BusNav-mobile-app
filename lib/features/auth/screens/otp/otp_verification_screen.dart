import 'package:busnav/features/auth/controllers/otp_login_controller.dart';
import 'package:busnav/routes/routes_names.dart';
import 'package:busnav/utils/constants/sizes.dart';
import 'package:busnav/utils/validators/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpLoginController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: IconButton(
              onPressed: () {
                controller.resetState();
                Get.offAllNamed(RoutesNames.login_screen);
              },
              icon: const Icon(CupertinoIcons.clear),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MySizes.spaceBtwSections),

              // Header
              Text("Verify Phone Number", style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: MySizes.spaceBtwItems),
              Text(textAlign: TextAlign.center, "We've sent a verification code to\n$phoneNumber", style: Theme.of(context).textTheme.labelMedium),
              SizedBox(height: MySizes.spaceBtwSections * 2),

              // OTP Form
              Form(
                key: controller.otpFormKey,
                child: Column(
                  children: [
                    // PIN Code Input
                    TextFormField(
                      controller: controller.otpCode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      // onCompleted: (v) {
                      //   // Auto verify when all digits are entered
                      //   controller.verifyOtpAndSignIn();
                      // },
                      onChanged: (value) {
                        // Optional: Real-time validation
                      },
                      // validator: (value) => MyValidator.validateOtp(value),
                    ),

                    SizedBox(height: MySizes.spaceBtwSections),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () => controller.verifyOtpAndSignIn(), child: const Text("Verify Code")),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MySizes.spaceBtwItems),

              // Resend Timer and Button
              Obx(() {
                return controller.resendTimer.value > 0
                    ? Text(
                        "Resend code in ${controller.resendTimer.value}s",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      )
                    : TextButton(onPressed: () => controller.resendOtp(), child: const Text("Resend Code"));
              }),

              SizedBox(height: MySizes.spaceBtwItems),

              // Change Phone Number
              TextButton.icon(
                onPressed: () {
                  controller.resetState();
                  Get.back();
                },
                icon: const Icon(Iconsax.edit, size: 16),
                label: const Text("Change Phone Number"),
              ),

              SizedBox(height: MySizes.spaceBtwSections),

              // Help Text
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.info_circle, color: Colors.blue, size: 20.r),
                        SizedBox(width: 8.w),
                        Text("Didn't receive the code?", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.blue)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "• Check your phone's message inbox\n• Make sure you have good signal reception\n• The code may take up to 2 minutes to arrive",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
