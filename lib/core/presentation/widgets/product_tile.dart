import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:flutter/material.dart';

class LargeProductTile extends StatelessWidget {
  const LargeProductTile({
    super.key,
    required this.product,
    required this.onFavoriteTap,
    required this.onTap,
  });

  final ShopProduct product;
  final VoidCallback onFavoriteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: Constants.padding,
        decoration: BoxDecoration(
          borderRadius: Constants.borderRadius,
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 150,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Product Image
                      Padding(
                          padding: Constants.padding,
                          child: product.images.isNotEmpty
                              ? Image.network(
                                  product.images[0].originalSrc!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/placeholder-image.png',
                                  fit: BoxFit.cover,
                                )),

                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(1),
                              Colors.black.withOpacity(.6),
                              Colors.black.withOpacity(.2),
                              Colors.black.withOpacity(0),
                            ],
                          ),
                        ),
                      ),

                      // Favorite Icon
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: Constants.padding,
                          child: GestureDetector(
                            onTap: onFavoriteTap,
                            child: const CustomIcon(
                              Icons.favorite_border,
                            ),
                          ),
                        ),
                      ),

                      // Product Name and Price
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: Constants.padding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextBody(
                                text: product.title,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 5),
                              TextBody(
                                text: product.productVariants[0].price,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
