import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/bloc/options_selection/options_selection_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/image_gallery.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom_template/core/constants.dart';

class ProductPage extends StatelessWidget {
  ProductPage({required this.id, super.key});

  final String id;
  final ShoppingBloc shopBloc = sl<ShoppingBloc>();
  final OptionsSelectionBloc optionsSelectionBloc = sl<OptionsSelectionBloc>();

  void getProduct() {
    shopBloc.add(GetProductByIdEvent(id: id));
  }

  void getSavedSelections() {
    optionsSelectionBloc.add(GetSavedSelectedOptionsEvent(productId: id));
  }

  void _addToBag({
    required ShopProduct product,
    required OptionsSelections selectedOptions,
    required int quantity,
    required BuildContext context,
  }) {
    final IncompleteBagItem bagItem = IncompleteBagItem(
      product: product,
      optionsSelections: selectedOptions,
      quantity: quantity,
    );
    BlocProvider.of<BagBloc>(context).add(AddBagItemEvent(bagItem: bagItem));
  }

  void changeSelectedOptions(String optionName, int indexValue,
      String productId, BuildContext context) {
    debugPrint(
        'changeSelectedOptions called: $optionName, $indexValue, $productId');
    BlocProvider.of<OptionsSelectionBloc>(context).add(
      OptionsSelectionChanged(
        optionName: optionName,
        indexValue: indexValue,
        productId: productId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Call bloc event to get product
    getProduct();
    getSavedSelections();
    return BlocProvider(
      create: (context) => optionsSelectionBloc,
      child: BlocProvider(
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
                                  return ImageGallery(
                                    images: state.product.images,
                                    onTap: (_) {},
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
                            /*  BlocBuilder<ShoppingBloc, ShoppingState>(
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
                              */

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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: TextSubHeadline(
                                                text: state.product.title,
                                              ),
                                            ),
                                            TextSubHeadline(
                                              text: state.product
                                                  .productVariants[0].price
                                                  .formattedPrice(),
                                            ),
                                          ],
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                  const StandardSpacing(
                                    multiplier: 0.5,
                                  ),

                                  //Current Variant Selected
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
                                      return BlocBuilder<OptionsSelectionBloc,
                                          OptionsSelectionState>(
                                        builder: (context, optionState) {
                                          if (optionState
                                              is OptionsSelectionLoadedState) {
                                            return const TextBody(
                                                text:
                                                    'Current Variant Selection Will Go Here');
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                      );
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
                                      // Select Options Title and Options Guide
                                      return ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              state.product.options.length,
                                          separatorBuilder: (context, index) {
                                            return const StandardSpacing(
                                                multiplier: 3);
                                          },
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: TextSubHeadline(
                                                            text:
                                                                '${state.product.options[index].name}')),
                                                    Flexible(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          CustomIcon(
                                                            CupertinoIcons
                                                                .info_circle,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 5,
                                                          ),
                                                          TextBody(
                                                            text:
                                                                '${state.product.options[index].name} Guide',
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const StandardSpacing(),
                                                Padding(
                                                    padding: Constants
                                                        .innerPadding
                                                        .copyWith(
                                                            top: 0,
                                                            bottom: 0,
                                                            left: 0),
                                                    child: BlocBuilder<
                                                            OptionsSelectionBloc,
                                                            OptionsSelectionState>(
                                                        builder: (context,
                                                            optionState) {
                                                      return buttons
                                                          .DropdownButton(
                                                        text: (optionState
                                                                    is! OptionsSelectionLoadedState ||
                                                                optionState
                                                                        .optionsSelection
                                                                        .selectedOptions
                                                                        .entries
                                                                        .length <=
                                                                    index)
                                                            ? 'Select ${state.product.options[index].name}'
                                                            : state
                                                                    .product
                                                                    .options[index]
                                                                    .values![
                                                                optionState
                                                                    .optionsSelection
                                                                    .selectedOptions
                                                                    .entries
                                                                    .elementAt(
                                                                        index)
                                                                    .value],
                                                        onTap: () async {
                                                          int? selIndex =
                                                              await buttons
                                                                  .showListSelectorModal(
                                                            context: context,
                                                            values: state
                                                                    .product
                                                                    .options[
                                                                        index]
                                                                    .values
                                                                    ?.toList() ??
                                                                [],
                                                            heading:
                                                                'Select ${state.product.options[index].name}',
                                                          );
                                                          if (selIndex !=
                                                              null) {
                                                            if (context
                                                                .mounted) {
                                                              changeSelectedOptions(
                                                                state
                                                                        .product
                                                                        .options[
                                                                            index]
                                                                        .name ??
                                                                    'N/A',
                                                                selIndex,
                                                                state
                                                                    .product.id,
                                                                context,
                                                              );
                                                            }
                                                          }
                                                        },
                                                      );
                                                    })),
                                              ],
                                            );
                                          });
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
                                          BlocBuilder<OptionsSelectionBloc,
                                                  OptionsSelectionState>(
                                              builder: (context, optionState) {
                                            OptionsSelections optionSelections;
                                            if (optionState
                                                is! OptionsSelectionLoadedState) {
                                              optionSelections =
                                                  const OptionsSelections(
                                                      selectedOptions: {});
                                            } else {
                                              optionSelections =
                                                  optionState.optionsSelection;
                                            }
                                            return buttons.CtaButton(
                                              onTap: () {
                                                _addToBag(
                                                  product: shopState.product,
                                                  selectedOptions:
                                                      optionSelections,
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
                                            );
                                          }),

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
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
