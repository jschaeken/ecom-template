import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart'
    as buttons;
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/bloc/options_selection/options_selection_bloc.dart';
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
                                            case OptionsSelectionLoadedIncompleteState:
                                              optionState
                                                  as OptionsSelectionLoadedIncompleteState;
                                              return TextBody(
                                                text: state.product
                                                    .productVariants[0].price
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
                                        return TextBody(
                                          text: optionState
                                              .bagItemData.productVariantTitle,
                                        );
                                      case OptionsSelectionLoadedIncompleteState:
                                        optionState
                                            as OptionsSelectionLoadedIncompleteState;
                                        return const TextBody(
                                          text: 'Select Options',
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

                                return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: state.product.options.length,
                                    separatorBuilder: (context, index) {
                                      return const StandardSpacing(
                                          multiplier: 3);
                                    },
                                    itemBuilder: (context, index) {
                                      String optionName =
                                          state.product.options[index].name ??
                                              'Option ${index + 1}';
                                      List<String> optionsValues =
                                          state.product.options[index].values ??
                                              [];
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: TextSubHeadline(
                                                text: optionName,
                                              )),
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
                                                    TextBody(
                                                      text: '$optionName Guide',
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
                                                top: 0,
                                                bottom: 0,
                                                left: 0,
                                              ),
                                              child: BlocBuilder<
                                                      OptionsSelectionBloc,
                                                      OptionsSelectionState>(
                                                  builder:
                                                      (context, optionState) {
                                                switch (
                                                    optionState.runtimeType) {
                                                  case OptionsSelectionInitial:
                                                    final Map<String, int>
                                                        selectedOptionsMap =
                                                        optionState
                                                            .optionsSelection
                                                            .selectedOptions;
                                                    bool chosen =
                                                        selectedOptionsMap[
                                                                optionName] !=
                                                            null;
                                                    return buttons
                                                        .DropdownButton(
                                                      text: chosen
                                                          ? optionsValues[
                                                              selectedOptionsMap[
                                                                  optionName]!]
                                                          : 'Select $optionName',
                                                      isInvalid: false,
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
                                                        if (selIndex != null) {
                                                          if (context.mounted) {
                                                            changeSelectedOptions(
                                                              context: context,
                                                              indexValue:
                                                                  selIndex,
                                                              optionName:
                                                                  optionName,
                                                              product:
                                                                  state.product,
                                                            );
                                                          }
                                                        }
                                                      },
                                                    );
                                                  case OptionsSelectionLoadingState:
                                                    return const LoadingStateWidget(
                                                      height: 50,
                                                    );
                                                  case OptionsSelectionLoadedCompleteState:
                                                    optionState
                                                        as OptionsSelectionLoadedCompleteState;
                                                    final Map<String, int>
                                                        selectedOptionsMap =
                                                        optionState
                                                            .optionsSelection
                                                            .selectedOptions;
                                                    bool chosen =
                                                        selectedOptionsMap[
                                                                optionName] !=
                                                            null;
                                                    return buttons
                                                        .DropdownButton(
                                                      text: chosen
                                                          ? optionsValues[
                                                              selectedOptionsMap[
                                                                  optionName]!]
                                                          : 'Select $optionName',
                                                      isInvalid: false,
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
                                                        if (selIndex != null) {
                                                          if (context.mounted) {
                                                            changeSelectedOptions(
                                                              context: context,
                                                              indexValue:
                                                                  selIndex,
                                                              optionName:
                                                                  optionName,
                                                              product:
                                                                  state.product,
                                                            );
                                                          }
                                                        }
                                                      },
                                                    );
                                                  case OptionsSelectionLoadedIncompleteState:
                                                    optionState
                                                        as OptionsSelectionLoadedIncompleteState;
                                                    final Map<String, int>
                                                        selectedOptionsMap =
                                                        optionState
                                                            .optionsSelection
                                                            .selectedOptions;
                                                    bool chosen =
                                                        selectedOptionsMap[
                                                                optionName] !=
                                                            null;
                                                    return buttons
                                                        .DropdownButton(
                                                      text: chosen
                                                          ? optionsValues[
                                                              selectedOptionsMap[
                                                                  optionName]!]
                                                          : 'Select $optionName',
                                                      isInvalid: !chosen,
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
                                                        if (selIndex != null) {
                                                          if (context.mounted) {
                                                            changeSelectedOptions(
                                                              context: context,
                                                              indexValue:
                                                                  selIndex,
                                                              optionName:
                                                                  optionName,
                                                              product:
                                                                  state.product,
                                                            );
                                                          }
                                                        }
                                                      },
                                                    );
                                                  case OptionsSelectionErrorState:
                                                    final Map<String, int>
                                                        selectedOptionsMap =
                                                        optionState
                                                            .optionsSelection
                                                            .selectedOptions;
                                                    bool active =
                                                        selectedOptionsMap[
                                                                optionName] !=
                                                            null;
                                                    return buttons
                                                        .DropdownButton(
                                                      text: active
                                                          ? optionsValues[
                                                              selectedOptionsMap[
                                                                  optionName]!]
                                                          : 'Select $optionName',
                                                      isInvalid: true,
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
                                                        if (selIndex != null) {
                                                          if (context.mounted) {
                                                            changeSelectedOptions(
                                                              context: context,
                                                              indexValue:
                                                                  selIndex,
                                                              optionName:
                                                                  optionName,
                                                              product:
                                                                  state.product,
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

                      const StandardSpacing(
                        multiplier: 2,
                      ),

                      // Quantity Selector
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
                                    const TextSubHeadline(
                                      text: 'Quantity',
                                    ),
                                    const Spacer(),
                                    BlocBuilder<OptionsSelectionBloc,
                                            OptionsSelectionState>(
                                        builder: (context, optionState) {
                                      switch (optionState.runtimeType) {
                                        case OptionsSelectionInitial:
                                          return buttons.QuantitySelector(
                                              quantity: optionState
                                                  .optionsSelection.quantity,
                                              onAdd: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .optionsSelection
                                                          .quantity +
                                                      1,
                                                );
                                              },
                                              onRemove: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .optionsSelection
                                                          .quantity -
                                                      1,
                                                );
                                              });
                                        case OptionsSelectionLoadingState:
                                          return const LoadingStateWidget(
                                            height: 50,
                                          );
                                        case OptionsSelectionLoadedCompleteState:
                                          optionState
                                              as OptionsSelectionLoadedCompleteState;
                                          return buttons.QuantitySelector(
                                              quantity: optionState
                                                  .optionsSelection.quantity,
                                              onAdd: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .optionsSelection
                                                          .quantity +
                                                      1,
                                                );
                                              },
                                              onRemove: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .optionsSelection
                                                          .quantity -
                                                      1,
                                                );
                                              });
                                        case OptionsSelectionLoadedIncompleteState:
                                          optionState
                                              as OptionsSelectionLoadedIncompleteState;
                                          return buttons.QuantitySelector(
                                              quantity: optionState
                                                  .optionsSelection.quantity,
                                              onAdd: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .optionsSelection
                                                          .quantity +
                                                      1,
                                                );
                                              },
                                              onRemove: () {
                                                changeQuantity(
                                                  context: context,
                                                  product: shopState.product,
                                                  quantity: optionState
                                                          .optionsSelection
                                                          .quantity -
                                                      1,
                                                );
                                              });
                                        case OptionsSelectionErrorState:
                                        default:
                                          return const SizedBox();
                                      }
                                    }),
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
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BlocBuilder<OptionsSelectionBloc,
                                            OptionsSelectionState>(
                                        builder: (context, optionState) {
                                      return buttons.CtaButton(
                                        onTap: () {
                                          switch (optionState.runtimeType) {
                                            case OptionsSelectionInitial:
                                              return;
                                            case OptionsSelectionLoadingState:
                                              return;
                                            case OptionsSelectionLoadedCompleteState:
                                              optionState
                                                  as OptionsSelectionLoadedCompleteState;
                                              _addToBag(
                                                bagItemData:
                                                    optionState.bagItemData,
                                                context: context,
                                              );
                                              return;
                                            case OptionsSelectionLoadedIncompleteState:
                                              optionState
                                                  as OptionsSelectionLoadedIncompleteState;
                                              _getSavedSelections(
                                                  context, shopState.product);
                                              return;
                                            case OptionsSelectionErrorState:
                                            default:
                                              return;
                                          }
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
