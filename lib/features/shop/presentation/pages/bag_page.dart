import 'package:flutter/material.dart';

class BagPage extends StatelessWidget {
  const BagPage({super.key, required this.pageTitle});

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(pageTitle),
    );
  }
}
