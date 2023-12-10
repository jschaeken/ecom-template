import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/presentation/widgets/quantity_selector.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter/material.dart';

class SavedProductListTile extends StatelessWidget {
  const SavedProductListTile({
    required this.title,
    required this.onTap,
    this.imageUrl,
    this.subHeadings,
    this.quantity,
    this.price,
    this.onQuantitySelectorTap,
    this.margin = false,
    this.isOutOfStock = false,
    super.key,
  });

  final String title;
  final Function onTap;
  final String? imageUrl;
  final List<String>? subHeadings;
  final int? quantity;
  final Price? price;
  final Function? onQuantitySelectorTap;
  final bool margin;
  final bool isOutOfStock;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: ClipRRect(
        borderRadius: Constants.borderRadius,
        child: Card(
            margin: margin ? null : const EdgeInsets.all(0),
            color: Theme.of(context).canvasColor,
            child: Stack(
              children: [
                // Product Tile
                Padding(
                  padding: Constants.padding,
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            image: imageUrl == null
                                ? const DecorationImage(
                                    image: AssetImage(
                                      'assets/images/placeholder-image.png',
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                      imageUrl!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        const StandardSpacing(
                          horizontalAxis: true,
                        ),

                        // Details Column
                        Flexible(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minHeight: 120,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Title
                                TextBody(
                                  text: title,
                                ),
                                const StandardSpacing(),

                                // Selected Options
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: subHeadings == null
                                      ? 0
                                      : subHeadings!.length,
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: Constants.padding
                                          .copyWith(left: 0, right: 0, top: 0),
                                      child: TextBody(
                                        text: subHeadings![i],
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                      ),
                                    );
                                  },
                                ),
                                // Price and Quantity Row
                                price == null
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextSubHeadline(
                                            text: price!.formattedPrice(),
                                          ),
                                          quantity == null
                                              ? const SizedBox()
                                              : QuantitySelectorButton(
                                                  quantity: quantity!,
                                                  onTap: () {
                                                    if (onQuantitySelectorTap !=
                                                        null) {
                                                      onQuantitySelectorTap!();
                                                    }
                                                  })
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Out of Stock
                if (isOutOfStock)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: TextBody(
                          text: 'Out of Stock',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}
