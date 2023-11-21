import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final String title;

  const AccountPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextBody(text: title),
      ),
    );
  }
}
