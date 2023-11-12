import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/presentation/widgets/quantity_selector.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:flutter/material.dart';

class SavedProductListTile extends StatelessWidget {
  const SavedProductListTile({
    required this.title,
    required this.onTap,
    this.imageUrl,
    this.optionsSelected,
    this.quantity,
    this.price,
    this.onQuantitySelectorTap,
    super.key,
  });

  final String title;
  final Function onTap;
  final String? imageUrl;
  final List<ShopProductSelectedOption>? optionsSelected;
  final int? quantity;
  final Price? price;
  final Function? onQuantitySelectorTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
          color: Theme.of(context).canvasColor,
          child: Padding(
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
                            itemCount: optionsSelected == null
                                ? 0
                                : optionsSelected!.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: Constants.padding
                                    .copyWith(left: 0, right: 0, top: 0),
                                child: TextBody(
                                  text:
                                      '${optionsSelected![i].name}: ${optionsSelected![i].value}',
                                  color:
                                      Theme.of(context).unselectedWidgetColor,
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
          )),
    );
  }
}
