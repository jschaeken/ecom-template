// ignore_for_file: deprecated_member_use

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final List<String> errors;

  LoginPage({this.errors = const [], super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: Padding(
        padding: Constants.padding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const StandardSpacing(multiplier: 1),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: errors.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: Constants.innerPadding.copyWith(left: 0, right: 0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Theme.of(context).colorScheme.error.withOpacity(0.3),
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
    );
  }
}
