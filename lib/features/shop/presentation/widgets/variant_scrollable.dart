import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:flutter/material.dart';

class VariantScrollable extends StatelessWidget {
  const VariantScrollable({
    super.key,
    required this.product,
    required this.selectedVariantIndex,
    required this.changeSelectedVariantIndex,
  });

  final ShopProduct product;
  final int selectedVariantIndex;
  final Function(int) changeSelectedVariantIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: product.productVariants.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: Constants.innerPadding
                .copyWith(right: 10, left: index == 0 ? 8 : 0),
            child: GestureDetector(
              onTap: () {
                changeSelectedVariantIndex(index);
              },
              child: Container(
                width: 61,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: index == selectedVariantIndex
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                      )),
                      child: Padding(
                        padding: Constants.innerPadding,
                        child: Image.network(
                          product.productVariants[index].image!.originalSrc,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
