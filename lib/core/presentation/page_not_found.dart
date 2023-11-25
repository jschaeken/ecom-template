import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            TextBody(
              text: 'Page Not Found',
            ),
            CustomIcon(CupertinoIcons.exclamationmark_triangle)
          ],
        ),
      ),
    );
  }
}
