import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuantitySelectorButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onTap;

  const QuantitySelectorButton(
      {required this.quantity, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          TextSubHeadline(text: 'Qty: $quantity'),
          const SizedBox(
            width: 3,
          ),
          const CustomIcon(CupertinoIcons.chevron_down, size: 16),
        ],
      ),
    );
  }
}

Future<int?> showQuantitySelectorModal(
    BuildContext context, BagItem bagItem) async {
  return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 600,
          child: Column(
            children: [
              const StandardSpacing(),
              const TextHeadline(text: 'Select Quantity'),
              const StandardSpacing(),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context, index + 1);
                      },
                      title: TextBody(text: '${index + 1}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
}
