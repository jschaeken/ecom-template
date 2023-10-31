import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';
import 'icon_components.dart';

class SlimTextTile extends StatelessWidget {
  const SlimTextTile({
    super.key,
    required this.text,
    required this.onTap,
    this.trailing = Icons.arrow_forward_ios,
  });

  final String text;
  final VoidCallback onTap;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: Constants.borderRadius,
      ),
      margin: Constants.padding.copyWith(top: 0),
      color: Theme.of(context).canvasColor,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: Constants.borderRadius,
        ),
        onTap: onTap,
        title: TextBody(text: text),
        trailing: CustomIcon(trailing),
      ),
    );
  }
}
