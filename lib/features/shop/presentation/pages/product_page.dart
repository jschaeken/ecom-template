import 'dart:developer';

import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/product_tile.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/bloc/options_selection/options_selection_bloc.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/image_gallery.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom_template/core/constants.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({required this.id, super.key});

  final String id;

  void _getProduct(BuildContext context) {
    BlocProvider.of<ShoppingBloc>(context).add(GetProductByIdEvent(id: id));
    BlocListener<ShoppingBloc, ShoppingState>(
      listener: (context, state) {
        if (state is ShoppingLoadedById) {
          _getSavedSelections(context, state.product);
        }
      },
    );
  }

  void _getSavedSelections(BuildContext context, ShopProduct product) {
    BlocProvider.of<OptionsSelectionBloc>(context)
        .add(CheckValidOptionsSelectionEvent(product: product));
  }

  void _newOptionSelectionState(BuildContext context) {
    BlocProvider.of<OptionsSelectionBloc>(context)
        .add(const OptionsSelectionStarted());
  }

  void _addToBag({
    required BagItemData bagItemData,
    required BuildContext context,
  }) {
    BlocProvider.of<BagBloc>(context)
        .add(AddBagItemEvent(bagItemData: bagItemData));
  }

  void changeSelectedOptions({
    required String optionName,
    required int indexValue,
    required ShopProduct product,
    required BuildContext context,
  }) {
    BlocProvider.of<OptionsSelectionBloc>(context).add(
      OptionsSelectionChanged(
        optionName: optionName,
        indexValue: indexValue,
        product: product,
      ),
    );
  }

  void changeQuantity({
    required int quantity,
    required ShopProduct product,
    required BuildContext context,
  }) {
    BlocProvider.of<OptionsSelectionBloc>(context).add(
      OptionsSelectionQuantityChanged(
        quantity: quantity,
        product: product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Call bloc event set options selection to loading
    _newOptionSelectionState(context);
    // Call bloc event to get product
    _getProduct(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // Title
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
            onRefresh: () async => _getProduct(context),
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
                                      BlocBuilder<OptionsSelectionBloc,
                                          OptionsSelectionState>(
                                        builder: (context, optionState) {
                                          switch (optionState.runtimeType) {
                                            case OptionsSelectionInitial:
                                              return TextBody(
                                                text: state.product
                                                    .productVariants[0].price
                                                    .formattedPrice(),
                                              );
                                            case OptionsSelectionLoadingState:
                                              return const LoadingStateWidget(
                                                height: 50,
                                              );
                                            case OptionsSelectionLoadedCompleteState:
                                              optionState
                                                  as OptionsSelectionLoadedCompleteState;
                                              return TextSubHeadline(
                                                text: state
                                                    .product.productVariants
                                                    .firstWhere(
                                                        (element) =>
                                                            element.id ==
                                                            optionState
                                                                .bagItemData
                                                                .productVariantId,
                                                        orElse: () => state
                                                            .product
                                                            .productVariants[0])
                                                    .price
                                                    .formattedPrice(),
                                              );
                                            case OptionsSelectionErrorState:
                                            default:
                                              return const SizedBox();
                                          }
                                        },
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
                                    switch (optionState.runtimeType) {
                                      case OptionsSelectionInitial:
                                        return const TextBody(
                                          text: 'Select Options',
                                        );
                                      case OptionsSelectionLoadingState:
                                        return const LoadingStateWidget(
                                          height: 50,
                                        );
                                      case OptionsSelectionLoadedCompleteState:
                                        optionState
                                            as OptionsSelectionLoadedCompleteState;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextBody(
                                              text: optionState.bagItemData
                                                  .productVariantTitle,
                                            ),
                                            //Out of stock
                                            state.product.availableForSale
                                                ? const SizedBox()
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.red[100],
                                                    ),
                                                    child: Padding(
                                                      padding: Constants
                                                          .innerPadding,
                                                      child: const TextBody(
                                                        text: 'Out of Stock',
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        );
                                      case OptionsSelectionErrorState:
                                      default:
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
                                BlocProvider.of<OptionsSelectionBloc>(context)
                                    .add(CheckValidOptionsSelectionEvent(
                                  product: state.product,
                                ));
                                return BlocBuilder<OptionsSelectionBloc,
                                    OptionsSelectionState>(
                                  builder: (context, optionState) {
                                    return ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: optionState.currentSelections
                                            .selections.length,
                                        separatorBuilder: (context, index) {
                                          return const StandardSpacing(
                                              multiplier: 3);
                                        },
                                        itemBuilder: (context, index) {
                                          String optionName = optionState
                                              .currentSelections
                                              .selections[index]
                                              .title;
                                          return Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: TextSubHeadline(
                                                    text: optionName,
                                                  )),
                                                ],
                                              ),
                                              const StandardSpacing(),
                                              Padding(
                                                  padding: Constants
                                                      .innerPadding
                                                      .copyWith(
                                                    top: 0,
                                                    bottom: 0,
                                                    left: 0,
                                                  ),
                                                  child: Builder(builder: (_) {
                                                    switch (optionState
                                                        .runtimeType) {
                                                      case OptionsSelectionInitial:
                                                        return const LoadingStateWidget(
                                                          height: 50,
                                                        );
                                                      case OptionsSelectionLoadingState:
                                                        return const LoadingStateWidget(
                                                          height: 50,
                                                        );
                                                      case OptionsSelectionLoadedCompleteState:
                                                        return buttons
                                                            .DropdownButton(
                                                          text: optionState
                                                              .currentSelections
                                                              .selections[index]
                                                              .chosenValue,
                                                          isInvalid: false,
                                                          onTap: () async {
                                                            int?
                                                                returnedSelectedIndex =
                                                                await buttons
                                                                    .showListSelectorModal(
                                                              context: context,
                                                              values: optionState
                                                                  .currentSelections
                                                                  .selections[
                                                                      index]
                                                                  .values
                                                                  .toList(),
                                                              heading:
                                                                  'Select ${optionState.currentSelections.selections[index].title}',
                                                            );
                                                            if (returnedSelectedIndex !=
                                                                null) {
                                                              if (context
                                                                  .mounted) {
                                                                changeSelectedOptions(
                                                                  context:
                                                                      context,
                                                                  indexValue:
                                                                      returnedSelectedIndex,
                                                                  optionName:
                                                                      optionName,
                                                                  product: state
                                                                      .product,
                                                                );
                                                              }
                                                            }
                                                          },
                                                        );
                                                      case OptionsSelectionErrorState:
                                                        return buttons
                                                            .DropdownButton(
                                                          text: optionState
                                                              .currentSelections
                                                              .selections[index]
                                                              .title,
                                                          isInvalid: false,
                                                          onTap: () async {
                                                            int?
                                                                returnedSelectedIndex =
                                                                await buttons
                                                                    .showListSelectorModal(
                                                              context: context,
                                                              values: optionState
                                                                  .currentSelections
                                                                  .selections[
                                                                      index]
                                                                  .values
                                                                  .toList(),
                                                              heading:
                                                                  'Select ${optionState.currentSelections.selections[index].title}',
                                                            );
                                                            if (returnedSelectedIndex !=
                                                                null) {
                                                              if (context
                                                                  .mounted) {
                                                                changeSelectedOptions(
                                                                  context:
                                                                      context,
                                                                  indexValue:
                                                                      returnedSelectedIndex,
                                                                  optionName:
                                                                      optionName,
                                                                  product: state
                                                                      .product,
                                                                );
                                                              }
                                                            }
                                                          },
                                                        );
                                                      default:
                                                        return const SizedBox();
                                                    }
                                                  })),
                                            ],
                                          );
                                        });
                                  },
                                );
                              } else if (state is ShoppingError) {
                                return const SizedBox();
                              } else {
                                return const SizedBox();
                              }
                            }),

                            const StandardSpacing(),

                            // Size Selector and favorite button
                            // TODO: Add favorite button
                          ],
                        ),
                      ),

                      // Quantity Selector and Like Button
                      Padding(
                        padding: Constants.padding,
                        child: Column(
                          children: [
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
                                return Row(
                                  children: [
                                    BlocBuilder<OptionsSelectionBloc,
                                            OptionsSelectionState>(
                                        builder: (context, optionState) {
                                      switch (optionState.runtimeType) {
                                        case OptionsSelectionInitial:
                                          return const LoadingStateWidget(
                                            height: 50,
                                            width: 50,
                                          );
                                        case OptionsSelectionLoadingState:
                                          return const LoadingStateWidget(
                                            height: 50,
                                            width: 50,
                                          );
                                        case OptionsSelectionLoadedCompleteState ||
                                              OptionsSelectionErrorState:
                                          return buttons.QuantitySelector(
                                              quantity: optionState
                                                  .currentSelections.quantity,
                                              onAdd: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .currentSelections
                                                          .quantity +
                                                      1,
                                                );
                                              },
                                              onRemove: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .currentSelections
                                                          .quantity -
                                                      1,
                                                );
                                              });
                                        default:
                                          return const SizedBox();
                                      }
                                    }),
                                    const Spacer(),
                                    // Favorite Button
                                    BlocBuilder<FavoritesBloc, FavoritesState>(
                                      builder: (context, favState) {
                                        switch (favState.runtimeType) {
                                          case FavoritesInitial:
                                            return const LoadingStateWidget(
                                              height: 50,
                                              width: 50,
                                            );
                                          case FavoritesLoading:
                                            return const LoadingStateWidget(
                                              height: 50,
                                              width: 50,
                                            );
                                          case FavoritesLoaded ||
                                                FavoritesAddedLoaded ||
                                                FavoritesRemovedLoaded ||
                                                FavoritesEmpty:
                                            final isFavorite = favState
                                                .favorites
                                                .map((e) => e.parentProdId)
                                                .toList()
                                                .contains(shopState.product.id);
                                            log('is favorite: $isFavorite');
                                            return FavoriteButton(
                                              isFavorite: isFavorite,
                                              onFavoriteTap: () {
                                                if (isFavorite) {
                                                  BlocProvider.of<
                                                              FavoritesBloc>(
                                                          context)
                                                      .add(
                                                    RemoveFavoriteEvent(
                                                      favorite: Favorite(
                                                        parentProdId: shopState
                                                            .product.id,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  BlocProvider.of<
                                                              FavoritesBloc>(
                                                          context)
                                                      .add(
                                                    AddFavoriteEvent(
                                                      favorite: Favorite(
                                                        parentProdId: shopState
                                                            .product.id,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            );
                                          case FavoritesError:
                                          default:
                                            return const SizedBox();
                                        }
                                      },
                                    )
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                          ],
                        ),
                      ),

                      // Accent Add to Bag, Apple Pay, Share buttons
                      Padding(
                        padding: Constants.padding,
                        child: Column(
                          children: [
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
                                log(shopState.product.productVariants.first
                                    .quantityAvailable
                                    .toString());
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BlocBuilder<OptionsSelectionBloc,
                                            OptionsSelectionState>(
                                        builder: (context, optionState) {
                                      switch (optionState.runtimeType) {
                                        case OptionsSelectionInitial:
                                          return buttons.CtaButton(
                                              color: Theme.of(context)
                                                  .unselectedWidgetColor,
                                              onTap: () {},
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
                                              ));
                                        case OptionsSelectionLoadingState:
                                          return const LoadingStateWidget(
                                            height: 50,
                                          );
                                        case OptionsSelectionLoadedCompleteState:
                                          optionState
                                              as OptionsSelectionLoadedCompleteState;
                                          final bool isOutOfStock =
                                              optionState.isOutOfStock;
                                          return Column(
                                            children: [
                                              buttons.CtaButton(
                                                disabled: isOutOfStock,
                                                onTap: () {
                                                  if (isOutOfStock) {
                                                    return;
                                                  } else {
                                                    _addToBag(
                                                      bagItemData: optionState
                                                          .bagItemData,
                                                      context: context,
                                                    );
                                                  }
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const CustomIcon(
                                                      CupertinoIcons.bag_fill,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    TextSubHeadline(
                                                      text: isOutOfStock
                                                          ? 'Out of Stock'
                                                          : 'Add to Bag',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const StandardSpacing(),

                                              // Apple Pay / Google Pay Button
                                              !isOutOfStock
                                                  ? buttons.CtaButton(
                                                      color: Colors.black,
                                                      onTap: () {},
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          );
                                        case OptionsSelectionErrorState:
                                          return buttons.CtaButton(
                                              color: Theme.of(context)
                                                  .unselectedWidgetColor,
                                              onTap: () {},
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
                                                    text: 'An error occured',
                                                  ),
                                                ],
                                              ));
                                        default:
                                          return const SizedBox();
                                      }
                                    }),

                                    const StandardSpacing(multiplier: 4),

                                    // Share button
                                    Center(
                                      child: buttons.CtaButton(
                                        width: 120,
                                        color: Theme.of(context).cardColor,
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
                          ],
                        ),
                      ),

                      // Description
                      Padding(
                        padding: Constants.padding,
                        child: BlocBuilder<ShoppingBloc, ShoppingState>(
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
                            return state.product.descriptionHtml == null
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
                      ),

                      const StandardSpacing(
                        multiplier: 2,
                      ),

                      // Material
                      Padding(
                        padding: Constants.padding,
                        child: BlocBuilder<ShoppingBloc, ShoppingState>(
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
                                for (final field in state.product.metafields)
                                  Column(
                                    children: [
                                      TextSubHeadline(
                                        text: field.namespace ?? 'Other Info',
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
                      ),

                      Padding(
                        padding: Constants.padding,
                        child: const Divider(),
                      ),

                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
