import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';

class CheckoutField extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onTapped;
  final Widget? leading;

  const CheckoutField({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTapped,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onTapped();
          },
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                TextSubHeadline(text: title),
                Row(
                  children: [
                    leading ?? Container(),
                    TextBody(
                      text: subtitle,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: Constants.innerPadding.copyWith(left: 0, right: 0),
          child: const Divider(),
        ),
      ],
    );
  }
}
