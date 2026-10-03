import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/auth_controller.dart';
import 'package:shop/route/route_constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthController _authController;

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
  }

  @override
  void dispose() {
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _onResetPassword() async {
    if (_formKey.currentState!.validate()) {
      final pass = _passController.text.trim();
      final confirmPass = _confirmPassController.text.trim();

      final success = await _authController.resetPassword(
        identity: _authController.forgotIdentity.value,
        otp: _authController.tempOtp.value,
        temporaryToken: _authController.temporaryToken.value,
        password: pass,
        confirmPassword: confirmPass,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authController.successMessage.value),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          logInScreenRoute,
          (route) => false,
        );
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
        title: const Text("Reset Password"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Set new password",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: defaultPadding / 2),
            const Text(
              "Your new password must be different from previously used passwords.",
            ),
            const SizedBox(height: defaultPadding * 1.5),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _passController,
                    validator: passwordValidator.call,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding * 0.75),
                        child: SvgPicture.asset(
                          "assets/icons/Lock.svg",
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.3),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  TextFormField(
                    controller: _confirmPassController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Confirm password is required';
                      }
                      if (val != _passController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm New Password",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding * 0.75),
                        child: SvgPicture.asset(
                          "assets/icons/Lock.svg",
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.3),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding * 2),
            Obx(
              () => ElevatedButton(
                onPressed:
                    _authController.isLoading.value ? null : _onResetPassword,
                child: _authController.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Reset Password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
