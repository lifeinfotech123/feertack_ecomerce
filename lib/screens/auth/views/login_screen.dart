import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/constants.dart';
import 'package:shop/controllers/auth_controller.dart';
import 'package:shop/route/route_constants.dart';
import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AuthController _authController;

  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
  }

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final success = await _authController.login(
        email: _email,
        password: _password,
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
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/login_dark.png",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Log in with your data that you entered during your registration.",
                  ),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                    formKey: _formKey,
                    onSavedEmail: (val) => _email = val?.trim() ?? '',
                    onSavedPassword: (val) => _password = val?.trim() ?? '',
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text("Forgot password"),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, passwordRecoveryScreenRoute);
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height > 700
                        ? size.height * 0.05
                        : defaultPadding,
                  ),
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          _authController.isLoading.value ? null : _onLogin,
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Log in"),
                    ),
                  ),
                  const SizedBox(height: defaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, signUpScreenRoute);
                        },
                        child: const Text("Sign up"),
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
