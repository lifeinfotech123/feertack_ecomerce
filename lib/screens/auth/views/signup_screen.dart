import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/controllers/auth_controller.dart';
import 'package:shop/screens/auth/views/components/sign_up_form.dart';
import 'package:shop/route/route_constants.dart';

import '../../../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthController _authController;

  String _fName = '';
  String _lName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPassword = '';
  bool _agreeTerms = true;

  @override
  void initState() {
    super.initState();
    _authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
  }

  void _onSignUp() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please agree to the Terms of Service & Privacy Policy"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final success = await _authController.register(
        fName: _fName,
        lName: _lName,
        email: _email,
        phone: _phone,
        password: _password,
        confirmPassword: _confirmPassword,
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
          entryPointScreenRoute,
          ModalRoute.withName(logInScreenRoute),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/signUp_dark.png",
              height: MediaQuery.of(context).size.height * 0.28,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let’s get started!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Please enter your valid data in order to create an account.",
                  ),
                  const SizedBox(height: defaultPadding),
                  SignUpForm(
                    formKey: _formKey,
                    onSavedFName: (val) => _fName = val?.trim() ?? '',
                    onSavedLName: (val) => _lName = val?.trim() ?? '',
                    onSavedEmail: (val) => _email = val?.trim() ?? '',
                    onSavedPhone: (val) => _phone = val?.trim() ?? '',
                    onSavedPassword: (val) => _password = val?.trim() ?? '',
                    onSavedConfirmPassword: (val) =>
                        _confirmPassword = val?.trim() ?? '',
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    children: [
                      Checkbox(
                        onChanged: (value) {
                          setState(() {
                            _agreeTerms = value ?? false;
                          });
                        },
                        value: _agreeTerms,
                      ),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: "I agree with the",
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                        context, termsOfServicesScreenRoute);
                                  },
                                text: " Terms of service ",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const TextSpan(
                                text: "& privacy policy.",
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: defaultPadding * 1.5),
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          _authController.isLoading.value ? null : _onSignUp,
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Continue"),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do you have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, logInScreenRoute);
                        },
                        child: const Text("Log in"),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
