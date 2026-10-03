import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.formKey,
    this.onSavedFName,
    this.onSavedLName,
    this.onSavedEmail,
    this.onSavedPhone,
    this.onSavedPassword,
    this.onSavedConfirmPassword,
  });

  final GlobalKey<FormState> formKey;
  final FormFieldSetter<String>? onSavedFName;
  final FormFieldSetter<String>? onSavedLName;
  final FormFieldSetter<String>? onSavedEmail;
  final FormFieldSetter<String>? onSavedPhone;
  final FormFieldSetter<String>? onSavedPassword;
  final FormFieldSetter<String>? onSavedConfirmPassword;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // First Name
          TextFormField(
            onSaved: widget.onSavedFName,
            validator: RequiredValidator(errorText: 'First name is required').call,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "First Name",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Last Name
          TextFormField(
            onSaved: widget.onSavedLName,
            validator: RequiredValidator(errorText: 'Last name is required').call,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Last Name",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: Icon(
                  Icons.person_outline,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Email
          TextFormField(
            onSaved: widget.onSavedEmail,
            validator: emaildValidator.call,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email address",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
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

          // Phone
          TextFormField(
            onSaved: widget.onSavedPhone,
            validator: RequiredValidator(errorText: 'Phone number is required').call,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone number",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: Icon(
                  Icons.phone_outlined,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.3),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          // Password
          TextFormField(
            controller: _passController,
            onSaved: widget.onSavedPassword,
            validator: passwordValidator.call,
            obscureText: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
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

          // Confirm Password
          TextFormField(
            onSaved: widget.onSavedConfirmPassword,
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
              hintText: "Confirm Password",
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
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
    );
  }
}
