import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/presentation/bloc/images/images_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/image_gallery.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:ecom_template/features/shop/presentation/widgets/variant_scrollable.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom_template/core/constants.dart';

class ProductPage extends StatelessWidget {
  ProductPage({required this.id, super.key});

  final String id;
  final ShoppingBloc shopBloc = sl<ShoppingBloc>();
  final ImagesBloc imagesBloc = sl<ImagesBloc>();

  void changeSelectedVariantIndex(int index) {
    imagesBloc.add(VariantImageSelected(index: index));
  }

  void getProduct() {
    shopBloc.add(GetProductByIdEvent(id: id));
  }

  void _addToBag({
    required ShopProduct product,
    required ShopProductProductVariant productVariant,
    required int quantity,
    required BuildContext context,
  }) {
    final BagItem bagItem = BagItem.fromShopProductVariant(
      product: productVariant,
      quantity: quantity,
      parentProductId: product.id,
    );
    BlocProvider.of<BagBloc>(context).add(AddBagItemEvent(bagItem: bagItem));
  }

  @override
  Widget build(BuildContext context) {
    // Call bloc event to get product
    getProduct();
    return BlocProvider(
      create: (_) => shopBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<ShoppingBloc, ShoppingState>(
            builder: (context, state) {
              if (state is ShoppingInitial) {
                return const InitialStateWidget();
              }
              if (state is ShoppingLoading) {
                return const TextBody(text: 'Loading...');
              }
              if (state is ShoppingLoadedById) {
                return TextHeadline(text: state.product.title);
              } else if (state is ShoppingError) {
                return const TextBody(text: 'Error');
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
            RefreshIndicator.adaptive(
                onRefresh: () async {
                  getProduct();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: BlocProvider(
                    create: (context) => imagesBloc,
                    child: Stack(
                      children: [
                        Column(
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
                                  return BlocBuilder<ImagesBloc, ImagesState>(
                                    builder: (context, imageState) {
                                      if (imageState is ImagesInitial ||
                                          imageState
                                              is VariantSelectionUpdate) {
                                        return ImageGallery(
                                          images: state.product.images,
                                          onTap: (imageUrl) {
                                            imagesBloc.add(
                                              MainImageSelected(
                                                imageUrl: imageUrl,
                                              ),
                                            );
                                          },
                                        );
                                      } else if (imageState
                                          is MainImageEnlarged) {
                                        return const LoadingStateWidget(
                                          height: 468,
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  );
                                } else if (state is ShoppingError) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 100),
                                      IconTextError(failure: state.failure),
                                    ],
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
                                  return BlocBuilder<ImagesBloc, ImagesState>(
                                      builder: (context, imagesState) {
                                    if (imagesState is ImagesInitial ||
                                        imagesState is VariantSelectionUpdate ||
                                        imagesState is MainImageEnlarged) {
                                      return VariantScrollable(
                                        product: state.product,
                                        selectedVariantIndex:
                                            imagesState.variantIndexSelected,
                                        changeSelectedVariantIndex:
                                            changeSelectedVariantIndex,
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  });
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
                                        return BlocBuilder<ImagesBloc,
                                                ImagesState>(
                                            builder: (context, imagesState) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: TextSubHeadline(
                                                  text: state.product.title,
                                                ),
                                              ),
                                              TextSubHeadline(
                                                text:
                                                    '${state.product.productVariants[imagesState.variantIndexSelected].price.currencyCode} ${state.product.productVariants[imagesState.variantIndexSelected].price.amount}',
                                              ),
                                            ],
                                          );
                                        });
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
                                      return BlocBuilder<ImagesBloc,
                                              ImagesState>(
                                          builder: (context, imagesState) {
                                        return TextBody(
                                          text: state
                                              .product
                                              .productVariants[imagesState
                                                  .variantIndexSelected]
                                              .title,
                                        );
                                      });
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),

                                  const StandardSpacing(multiplier: 2),

                                  BlocBuilder<ShoppingBloc, ShoppingState>(
                                      builder: (context, state) {
                                    if (state is ShoppingInitial) {
                                      return const SizedBox();
                                    }
                                    if (state is ShoppingLoading) {
                                      return const LoadingStateWidget(
                                        height: 50,
                                      );
                                    }
                                    if (state is ShoppingLoadedById) {
                                      // Select Size Title and Size Guide
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Expanded(
                                                child: TextSubHeadline(
                                                  text: 'Select Size',
                                                ),
                                              ),
                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CustomIcon(
                                                      CupertinoIcons
                                                          .info_circle,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    const TextBody(
                                                      text: 'Size Guide',
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const StandardSpacing(),
                                          Padding(
                                            padding: Constants.innerPadding
                                                .copyWith(
                                                    top: 0, bottom: 0, left: 0),
                                            child: buttons.DropdownButton(
                                              text: 'Select Size',
                                              onTap: () async {},
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (shopBloc.state
                                        is ShoppingError) {
                                      return const SizedBox();
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),

                                  const StandardSpacing(),

                                  // Size Selector and favorite button

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

                                  // Accent Add to Bag, Apple Pay, Share buttons
                                  BlocBuilder<ShoppingBloc, ShoppingState>(
                                      builder: (context, shopState) {
                                    if (shopState is ShoppingInitial) {
                                      return const InitialStateWidget();
                                    }
                                    if (shopState is ShoppingLoading) {
                                      return const LoadingStateWidget(
                                        height: 50,
                                      );
                                    }
                                    if (shopState is ShoppingLoadedById) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          buttons.CtaButton(
                                            onTap: () {
                                              _addToBag(
                                                product: shopState.product,
                                                productVariant: shopState
                                                        .product
                                                        .productVariants[
                                                    imagesBloc.state
                                                        .variantIndexSelected],
                                                quantity: 1,
                                                context: context,
                                              );
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                              color:
                                                  Theme.of(context).cardColor,
                                              onTap: () {},
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),

                                  // Description
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
                                      return state.product.descriptionHtml ==
                                              null
                                          ? const SizedBox()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const StandardSpacing(
                                                    multiplier: 2),

                                                // Description
                                                const TextSubHeadline(
                                                  text: 'Description',
                                                ),
                                                TextBody(
                                                  text: state
                                                      .product.description!,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (final field
                                              in state.product.metafields)
                                            Column(
                                              children: [
                                                TextSubHeadline(
                                                  text: field.namespace ??
                                                      'Other Info',
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

                                  Padding(
                                    padding: Constants.padding,
                                    child: const Divider(),
                                  ),

                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
