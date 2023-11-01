import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:flutter/material.dart';

Future<Size?> showSizeModal(BuildContext context, String productName,
    ShopProductProductVariant productVariant) async {
  return await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: Constants.borderRadius.copyWith(
            bottomLeft: const Radius.circular(0),
            bottomRight: const Radius.circular(0),
          ),
        ),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: Constants.padding,
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    productVariant.image?.originalSrc == null
                        ? const SizedBox()
                        : Flexible(
                            child: Image.network(
                              productVariant.image!.originalSrc,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: Constants.padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: Constants.innerPadding,
                              child: TextSubHeadline(text: productName),
                            ),
                            Padding(
                              padding: Constants.innerPadding,
                              child:
                                  const TextBody(text: 'productVariant.name'),
                            ),
                            Padding(
                              padding: Constants.innerPadding,
                              child: const TextSubHeadline(
                                  text:
                                      '€productVariant.price.toStringAsFixed(2)'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: Constants.padding,
              child: const TextHeadline(text: 'Select Size'),
            ),
            // ListView.builder(
            //   padding: Constants.padding.copyWith(top: 0, bottom: 0),
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: productVariant.sizes!.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return Material(
            //       color: Colors.transparent,
            //       child: ListTile(
            //           contentPadding: EdgeInsets.zero,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: Constants.borderRadius,
            //           ),
            //           onTap: () {
            //             Navigator.pop(context, productVariant.sizes![index]);
            //           },
            //           title: TextBody(
            //             text: productVariant.sizes![index].name,
            //           ),
            //           trailing: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Padding(
            //                 padding: Constants.padding.copyWith(left: 0),
            //                 child: const TextSubHeadline(
            //                   text: 'Select',
            //                 ),
            //               ),
            //               const CustomIcon(
            //                 Icons.add_circle_outline_rounded,
            //               ),
            //             ],
            //           )),
            //     );
            //   },
            // )
          ]),
        ),
      );
    },
  );
}
