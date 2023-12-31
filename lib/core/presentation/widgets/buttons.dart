import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownButton extends StatelessWidget {
  const DropdownButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isInvalid = false,
  });

  final String text;
  final VoidCallback onTap;
  final bool isInvalid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isInvalid ? Colors.red : Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        height: 45,
        child: Padding(
          padding: Constants.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextBody(text: text),
              CustomIcon(
                CupertinoIcons.chevron_down,
                color: Theme.of(context).primaryColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
    this.width = double.infinity,
    this.height = 50,
    this.disabled = false,
  });

  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  final double width;
  final double height;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Material(
        color: disabled
            ? Theme.of(context).unselectedWidgetColor
            : color ?? Theme.of(context).indicatorColor,
        borderRadius: Constants.borderRadius,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: Constants.borderRadius,
          child: Container(
            alignment: Alignment.center,
            //stadium border
            decoration: BoxDecoration(
              borderRadius: Constants.borderRadius,
            ),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

Future<int?> showListSelectorModal({
  required BuildContext context,
  required String heading,
  required List<String> values,
}) async {
  return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 600,
          child: Column(
            children: [
              const StandardSpacing(),
              TextHeadline(text: heading),
              const StandardSpacing(),
              Expanded(
                child: ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context, index);
                      },
                      title: TextBody(text: values[index].toString()),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
}

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                onRemove();
              },
              child: Container(
                alignment: Alignment.center,
                child: CustomIcon(
                  CupertinoIcons.minus,
                  color: Theme.of(context).primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: TextBody(text: quantity.toString()),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                onAdd();
              },
              child: Container(
                alignment: Alignment.center,
                child: CustomIcon(
                  CupertinoIcons.plus,
                  color: Theme.of(context).primaryColor,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
