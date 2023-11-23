import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;

class ContinueToPaymentButton extends StatelessWidget {
  const ContinueToPaymentButton({
    required this.onTap,
    super.key,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.padding.copyWith(top: 0, bottom: 0),
      child: buttons.CtaButton(
        height: 50,
        width: double.infinity,
        color: Theme.of(context).indicatorColor,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextHeadline(
              text: 'Continue To Payment',
              color: Theme.of(context).canvasColor,
            ),
          ],
        ),
      ),
    );
  }
}

class ApplePayButton extends StatelessWidget {
  const ApplePayButton({
    required this.onTap,
    super.key,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.padding.copyWith(top: 0, bottom: 0),
      child: buttons.CtaButton(
        height: 50,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              Icons.apple,
              color: Theme.of(context).canvasColor,
            ),
            const SizedBox(
              width: 5,
            ),
            TextHeadline(
              text: 'Pay',
              color: Theme.of(context).canvasColor,
            ),
          ],
        ),
      ),
    );
  }
}
