import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/auth_controller.dart';
import 'package:shop/route/route_constants.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthController _authController;
  late final TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
    _otpController =
        TextEditingController(text: _authController.tempOtp.value);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerifyOtp() async {
    if (_formKey.currentState!.validate()) {
      final otp = _otpController.text.trim();
      final identity = _authController.forgotIdentity.value;

      final success = await _authController.verifyOtp(
        identity: identity,
        otp: otp,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authController.successMessage.value),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, newPasswordScreenRoute);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authController.errorMessage.value),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "OTP Verification",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: defaultPadding / 2),
            Obx(
              () => Text(
                "Enter the 4-digit code sent to ${_authController.forgotIdentity.value}",
              ),
            ),
            const SizedBox(height: defaultPadding * 1.5),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter OTP';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: defaultPadding * 0.75),
                    child: Icon(
                      Icons.pin_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding * 2),
            Obx(
              () => ElevatedButton(
                onPressed:
                    _authController.isLoading.value ? null : _onVerifyOtp,
                child: _authController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Verify OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
