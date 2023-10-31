import 'package:ecom_template/core/presentation/widgets/custom_shapes.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/image_gallery.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;
import 'package:ecom_template/core/presentation/widgets/variant_scrollable.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_placeholders.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({required this.id, super.key});

  final String id;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ShoppingBloc bloc;

  // TODO: Swap widget level state management for bloc state management
  int selectedVariantIndex = 0;
  int imageIndex = 0;
  Size? selectedSize;
  bool overlayAddToBag = false;
  final ScrollController scrollController = ScrollController();
  // TODO: Swap widget level state management for bloc state management

  void changeSelectedVariantIndex(int index) {
    setState(() {
      selectedVariantIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    bloc = sl<ShoppingBloc>();

    // Call bloc event to get product
    bloc.add(GetProductByIdEvent(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<ShoppingBloc, ShoppingState>(
            builder: (context, state) {
              if (state is ShoppingInitial) {
                return const InitialStateWidget();
              }
              if (state is ShoppingLoading) {
                return const Text('Loading...');
              }
              if (state is ShoppingLoadedById) {
                return TextHeadline(text: state.product.title);
              } else {
                return const SizedBox();
              }
            },
          ),
          automaticallyImplyLeading: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const CustomIcon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Builder(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Slidable Gallery
                      BlocBuilder<ShoppingBloc, ShoppingState>(
                        builder: (context, state) {
                          if (state is ShoppingInitial) {
                            return const InitialStateWidget();
                          }
                          if (state is ShoppingLoading) {
                            return const LoadingStateWidget(
                              height: 468,
                            );
                          }
                          if (state is ShoppingLoadedById) {
                            return ImageGallery(
                              images: state.product.images,
                              onTap: (index) => {},
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),

                      Padding(
                        padding: Constants.innerPadding,
                        child: const SizedBox(),
                      ),

                      // Variant Selector (Scrollable Image List)
                      BlocBuilder<ShoppingBloc, ShoppingState>(
                        builder: (context, state) {
                          if (state is ShoppingInitial) {
                            return const InitialStateWidget();
                          }
                          if (state is ShoppingLoading) {
                            return Padding(
                              padding: Constants.padding,
                              child: const LoadingStateWidget(
                                height: 85,
                              ),
                            );
                          }
                          if (state is ShoppingLoadedById) {
                            return VariantScrollable(
                              product: state.product,
                              selectedVariantIndex: selectedVariantIndex,
                              changeSelectedVariantIndex:
                                  changeSelectedVariantIndex,
                            );
                          }
                          return const SizedBox();
                        },
                      ),

                      const StandardSpacing(),

                      // Product Details
                      Padding(
                        padding: Constants.padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name and price row
                            BlocBuilder<ShoppingBloc, ShoppingState>(
                              builder: (context, state) {
                                if (state is ShoppingInitial) {
                                  return const InitialStateWidget();
                                }
                                if (state is ShoppingLoading) {
                                  return const LoadingStateWidget(
                                    height: 20,
                                  );
                                }
                                if (state is ShoppingLoadedById) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBody(text: state.product.title),
                                      TextSubHeadline(
                                          text: state
                                              .product
                                              .productVariants[
                                                  selectedVariantIndex]
                                              .price),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),

                            const StandardSpacing(
                              multiplier: 0.5,
                            ),
                            //Variant Name
                            BlocBuilder<ShoppingBloc, ShoppingState>(
                                builder: (context, state) {
                              if (state is ShoppingInitial) {
                                return const InitialStateWidget();
                              }
                              if (state is ShoppingLoading) {
                                return const LoadingStateWidget(
                                  height: 50,
                                );
                              }
                              if (state is ShoppingLoadedById) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextBody(
                                        text: state
                                            .product
                                            .productVariants[
                                                selectedVariantIndex]
                                            .title,
                                        color: Theme.of(context)
                                            .unselectedWidgetColor),
                                    const StandardSpacing(
                                      multiplier: 0.5,
                                    ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),

                            // Reviews by stars

                            // const StandardSpacing(multiplier: 2),
                            // BlocBuilder<ShoppingBloc, ShoppingState>(
                            //     builder: (context, state) {
                            //   if (state is ShoppingInitial) {
                            //     return const InitialStateWidget();
                            //   }
                            //   if (state is ShoppingLoading) {
                            //     return const LoadingStateWidget(
                            //       height: 50,
                            //     );
                            //   }
                            //   if (state is ShoppingLoadedById) {
                            //     return Row(
                            //   children: [
                            //     for (int i = 0; i < 5; i++)
                            //       Padding(
                            //         padding:
                            //             Constants.innerPadding.copyWith(left: 0),
                            //         child: state.product.rating.average.toInt() > i
                            //             ? const CustomIcon(
                            //                 Icons.star,
                            //                 size: 14,
                            //               )
                            //             :
                            //             //Mask over the star to show 10ths of a star
                            //             CustomStar(
                            //                 size: 14,
                            //                 fillAmount:
                            //                     state.product.rating.average - i > 0
                            //                         ? state.product.rating.average - i
                            //                         : 0,
                            //               ),
                            //       ),
                            //     Padding(
                            //       padding: Constants.innerPadding,
                            //       child: const TextBody(
                            //         text: 'rating.average',
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: Constants.padding
                            //           .copyWith(top: 0, left: 10, bottom: 0),
                            //       child: const TextBody(
                            //         text: 'product.rating.count',
                            //         fontWeight: FontWeight.w900,
                            //         decoration: TextDecoration.underline,
                            //       ),
                            //     ),
                            //   ],
                            // );
                            //   } else {
                            //     return const SizedBox();
                            //   }
                            // }),

                            const StandardSpacing(multiplier: 2),

                            // Select Size Title and Size Guide
                            Row(
                              children: [
                                const Expanded(
                                  child: TextSubHeadline(
                                    text: 'Select Size',
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomIcon(
                                        CupertinoIcons.info_circle,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const TextBody(
                                        text: 'Size Guide',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const StandardSpacing(),

                            // Size Selector and favorite button
                            // Row(
                            //   children: [
                            //     Flexible(
                            //       flex: 4,
                            //       child: Padding(
                            //         padding: Constants.innerPadding
                            //             .copyWith(top: 0, bottom: 0, left: 0),
                            //         child: buttons.DropdownButton(
                            //           text: product
                            //                       .productVariants[
                            //                           selectedVariantIndex]
                            //                       .selectedOptions !=
                            //                   null
                            //               ? selectedSize == null
                            //                   ? 'Select Size'
                            //                   : 'selectedSize'
                            //               : 'One Size',
                            //           onTap: () async {
                            //             Size? res = await showSizeModal(
                            //               product.title,
                            //               product.productVariants[
                            //                   selectedVariantIndex],
                            //             );
                            //             setNewSize(res);
                            //           },
                            //         ),
                            //       ),
                            //     ),

                            //     // Favorite Button
                            //     Flexible(
                            //       flex: 1,
                            //       child: Padding(
                            //         padding: Constants.innerPadding
                            //             .copyWith(top: 0, bottom: 0, right: 0),
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //             color: Theme.of(context).cardColor,
                            //             shape: BoxShape.circle,
                            //           ),
                            //           child: const Padding(
                            //             padding: EdgeInsets.all(9),
                            //             child: Center(
                            //               child: CustomIcon(
                            //                 Icons.favorite_border,
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),

                            const StandardSpacing(
                              multiplier: 2,
                            ),

                            // Accent Add to bag button
                            buttons.CtaButton(
                              onTap: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIcon(
                                    CupertinoIcons.bag_fill,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  TextSubHeadline(
                                    text: 'Add to Bag',
                                  ),
                                ],
                              ),
                            ),

                            const StandardSpacing(),

                            // Apple Pay / Google Pay Button
                            buttons.CtaButton(
                              color: Colors.black,
                              onTap: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIcon(
                                    Icons.apple,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  TextSubHeadline(
                                    text: 'Pay',
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),

                            const StandardSpacing(multiplier: 4),

                            // Share button
                            Center(
                              child: buttons.CtaButton(
                                width: 120,
                                color: Theme.of(context).cardColor,
                                onTap: () {},
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CustomIcon(
                                        CupertinoIcons.share,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    TextBody(text: 'Share'),
                                  ],
                                ),
                              ),
                            ),

                            BlocBuilder<ShoppingBloc, ShoppingState>(
                                builder: (context, state) {
                              if (state is ShoppingInitial) {
                                return const InitialStateWidget();
                              }
                              if (state is ShoppingLoading) {
                                return const LoadingStateWidget(
                                  height: 50,
                                );
                              }
                              if (state is ShoppingLoadedById) {
                                return state.product.description == null
                                    ? const SizedBox()
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const StandardSpacing(multiplier: 2),

                                          // Description
                                          const TextSubHeadline(
                                            text: 'Description',
                                          ),
                                          TextBody(
                                            text: state.product.description!,
                                          ),
                                        ],
                                      );
                              } else {
                                return const SizedBox();
                              }
                            }),

                            const StandardSpacing(
                              multiplier: 2,
                            ),

                            // Material
                            BlocBuilder<ShoppingBloc, ShoppingState>(
                                builder: (context, state) {
                              if (state is ShoppingInitial) {
                                return const InitialStateWidget();
                              }
                              if (state is ShoppingLoading) {
                                return const LoadingStateWidget(
                                  height: 50,
                                );
                              }
                              if (state is ShoppingLoadedById) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final field
                                        in state.product.metafields)
                                      Column(
                                        children: [
                                          TextSubHeadline(
                                            text:
                                                field.namespace ?? 'Other Info',
                                          ),
                                          TextBody(
                                            text: field.value ?? '',
                                          ),
                                        ],
                                      ),
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ],
                        ),
                      ),

                      Padding(
                        padding: Constants.padding,
                        child: const Divider(),
                      ),

                      // Reviews and Feedback
                      // TODO : Add reviews and feedback
                      Column(
                        children: [
                          BlocBuilder<ShoppingBloc, ShoppingState>(
                              builder: (context, state) {
                            if (state is ShoppingInitial) {
                              return const InitialStateWidget();
                            }
                            if (state is ShoppingLoading) {
                              return const LoadingStateWidget(
                                height: 50,
                              );
                            }
                            if (state is ShoppingLoadedById) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: Constants.padding,
                                    child: const Center(
                                      child: TextSubHeadline(
                                        text: 'Reviews and Feedback',
                                      ),
                                    ),
                                  ),
                                  const TextMassive(text: '0.0'),
                                  //Stars
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0; i < 5; i++)
                                        Padding(
                                          padding: Constants.innerPadding
                                              .copyWith(left: 0),
                                          child: 0 > i
                                              ? const CustomIcon(
                                                  Icons.star,
                                                  size: 45,
                                                )
                                              :
                                              //Mask over the star to show 10ths of a star
                                              CustomStar(
                                                  fillAmount:
                                                      0.0 - i > 0 ? 0.0 - i : 0,
                                                ),
                                        ),
                                    ],
                                  ),

                                  Padding(
                                    padding: Constants.padding,
                                    child: const TextHeadline(
                                      text: 'Based on 0 reviews',
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),

                          Padding(
                            padding: Constants.padding,
                            child: const TextBody(
                              text:
                                  'All reviews are written by verified buyers',
                            ),
                          ),

                          // Review Cards
                          for (int i = 0; i < 1; i++)
                            Padding(
                                padding: Constants.padding,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: Constants.borderRadius,
                                  ),
                                  child: Padding(
                                    padding: Constants.padding,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Rating
                                        Row(
                                          children: [
                                            for (int j = 0; j < 5; j++)
                                              5.0 > i
                                                  ? const CustomIcon(
                                                      Icons.star,
                                                      size: 20,
                                                    )
                                                  :

                                                  //Mask over the star to show 10ths of a star
                                                  CustomStar(
                                                      size: 20,
                                                      fillAmount: 5.0 - i > 0
                                                          ? 5.0 - i
                                                          : 0,
                                                    ),
                                            Padding(
                                              padding: Constants.innerPadding,
                                              child: const TextBody(
                                                text: '5.0',
                                              ),
                                            ),
                                          ],
                                        ),

                                        const StandardSpacing(),

                                        // Title
                                        const TextBody(
                                          text: 'Great product',
                                          fontWeight: FontWeight.bold,
                                        ),

                                        const StandardSpacing(),

                                        // Description
                                        const TextBody(text: 'Description'),

                                        const StandardSpacing(),

                                        // Author and Date
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextBody(
                                              text: 'Author',
                                              color: Theme.of(context)
                                                  .unselectedWidgetColor,
                                            ),
                                            TextBody(
                                              text: 'Date',
                                              color: Theme.of(context)
                                                  .unselectedWidgetColor,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                        ],
                      ),

                      // Related Products

                      const SizedBox(
                        height: 200,
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Size?> showSizeModal(
      String productName, ShopProductProductVariant productVariant) async {
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

  void setNewSize(Size? res) {
    if (res != null) {
      setState(() {
        selectedSize = res;
      });
    }
  }
}
