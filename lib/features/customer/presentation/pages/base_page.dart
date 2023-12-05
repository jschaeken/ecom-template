import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Create Account Page

class BasePage extends StatelessWidget {
  final List<String> errors;

  BasePage({required this.errors, super.key});

  List<String> fields = [
    'First Name',
    'Last Name',
    'Email',
    'Phone',
    'Password',
    'Confirm Password',
  ];

  final List<TextEditingController> controllers = [
    // First Name Textfield
    TextEditingController(),

    // Last Name Textfield
    TextEditingController(),

    // Email Textfield
    TextEditingController(),

    // Phone Textfield
    TextEditingController(),

    // Password Textfield
    TextEditingController(),

    // Confirm Password Textfield
    TextEditingController(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: Constants.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: double.infinity),
          const TextHeadline(text: 'Create Account'),
          // Textfields
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: fields.length,
            itemBuilder: (context, index) {
              return TextField(
                controller: controllers[index],
                decoration: InputDecoration(labelText: fields[index]),
              );
            },
          ),

          const StandardSpacing(multiplier: 2),

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
                    color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  ),
                  width: double.infinity,
                  // height: 50,
                  child: TextBody(
                    margin: Constants.padding,
                    text: errors[index],
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                    maxLines: 10,
                  ),
                ),
              );
            },
          ),

          const StandardSpacing(multiplier: 2),
          // Create Account Button
          CtaButton(
            onTap: () {
              BlocProvider.of<CustomerAuthBloc>(context).add(
                CreateAccountEvent(
                  email: controllers[2].text,
                  firstName: controllers[0].text,
                  lastName: controllers[1].text,
                  phone: controllers[3].text,
                  password: controllers[4].text,
                  confirmPassword: controllers[5].text,
                  acceptsMarketing: false,
                ),
              );
            },
            child: const TextBody(text: 'Create Account'),
          ),
          const StandardSpacing(),
          // Login Button
          CtaButton(
            color: Theme.of(context).secondaryHeaderColor,
            onTap: () {
              BlocProvider.of<CustomerAuthBloc>(context)
                  .add(PushLoginStateEvent());
            },
            child:
                TextBody(text: 'Login', color: Theme.of(context).canvasColor),
          ),
        ],
      ),
    ));
  }
}
