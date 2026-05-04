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

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpLoginController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: IconButton(
              onPressed: () {
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
              Text("Phone Login", style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: MySizes.spaceBtwItems),
              Text(
                textAlign: TextAlign.center,
                "Enter your phone number and we'll send you a verification code to sign in to your account.",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: MySizes.spaceBtwSections * 2),

              // Phone Number Form
              Form(
                key: controller.phoneFormKey,
                child: Column(
                  children: [
                    // Phone Number Input
                    TextFormField(
                      controller: controller.phoneNumber,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s\(\)]'))],
                      decoration: const InputDecoration(labelText: "Phone Number", hintText: "+1 (555) 123-4567", prefixIcon: Icon(Iconsax.call)),
                      validator: (value) => MyValidator.validatePhoneNumber(value),
                    ),
                    SizedBox(height: MySizes.spaceBtwSections),

                    // Send OTP Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () => controller.sendOtp(), child: const Text("Send Verification Code")),
                    ),
                  ],
                ),
              ),

              SizedBox(height: MySizes.spaceBtwItems),

              // Divider
              Row(
                children: [
                  Flexible(child: Divider(color: Colors.grey.withOpacity(0.4), thickness: 0.5, indent: 60, endIndent: 5)),
                  Text("OR", style: Theme.of(context).textTheme.labelMedium),
                  Flexible(child: Divider(color: Colors.grey.withOpacity(0.4), thickness: 0.5, indent: 5, endIndent: 60)),
                ],
              ),

              SizedBox(height: MySizes.spaceBtwItems),

              // Back to Email Login
              TextButton(onPressed: () => Get.offAllNamed(RoutesNames.login_screen), child: const Text("Back to Email Login")),

              SizedBox(height: MySizes.spaceBtwItems * 2),

              // Terms and Conditions
              Text(
                textAlign: TextAlign.center,
                "By continuing, you agree to our Terms of Service and Privacy Policy. SMS charges may apply.",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
