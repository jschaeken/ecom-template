// ignore_for_file: deprecated_member_use

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/safe_image.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final List<String> errors;
  final bool isLoading;

  LoginPage({this.errors = const [], required this.isLoading, super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Stack(
        children: [
          Padding(
            padding: Constants.padding,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: const SafeImage(
                    assetUrl: 'assets/images/esd_demo_logo.png',
                    imageUrl: null,
                    width: 200,
                  ),
                ),

                const StandardSpacing(multiplier: 6),

                CustomTextfield(
                  controller: emailController,
                  text: 'Email',
                ),

                const StandardSpacing(),

                CustomTextfield(
                  controller: passwordController,
                  text: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  // obscureText: true,
                ),

                const StandardSpacing(multiplier: 1),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: errors.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          Constants.innerPadding.copyWith(left: 0, right: 0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.3),
                        ),
                        width: double.infinity,
                        // height: 50,
                        child: TextBody(
                          margin: Constants.padding,
                          text: errors[index],
                          color: Theme.of(context).errorColor,
                          fontWeight: FontWeight.bold,
                          maxLines: 10,
                        ),
                      ),
                    );
                  },
                ),
                const StandardSpacing(multiplier: 1),
                CtaButton(
                  onTap: () {
                    debugPrint(
                        'Login: ${emailController.text}, ${passwordController.text}');
                    BlocProvider.of<CustomerAuthBloc>(context).add(
                      CustomerAuthEmailAndPasswordSignInEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  child: const TextBody(text: 'Login'),
                ),
                const StandardSpacing(multiplier: 1),
                // Create Account Button
                CtaButton(
                  color: Theme.of(context).secondaryHeaderColor,
                  onTap: () {
                    BlocProvider.of<CustomerAuthBloc>(context)
                        .add(PushCreateAccountStateEvent());
                  },
                  child: TextBody(
                    text: 'Create Account',
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Theme.of(context).canvasColor.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomTextfield extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool obscureText;

  const CustomTextfield({
    super.key,
    required this.text,
    required this.controller,
    this.keyboardType,
    this.errorText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      cursorColor: Theme.of(context).primaryColor,
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        errorText: errorText,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).unselectedWidgetColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}
