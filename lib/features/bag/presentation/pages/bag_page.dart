import 'dart:developer';

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/saved_product_list_tile.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/widgets/quantity_selector.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/pages/checkout_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/product_page.dart';
import 'package:ecom_template/features/shop/presentation/widgets/empty_view.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopify_flutter/models/models.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key, required this.pageTitle});

  final String pageTitle;

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  late CheckoutBloc checkoutBloc;

  @override
  void initState() {
    super.initState();
    checkoutBloc = BlocProvider.of<CheckoutBloc>(context);
  }

  void navigateToProductPage(String productId, BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ProductPage(
          id: productId,
        ),
      ),
    );
  }

  void updateBagItemQuantity(
      BagItem bagItem, int quantity, BuildContext context) {
    BlocProvider.of<BagBloc>(context).add(
      UpdateBagItemQuantityEvent(
        bagItem: bagItem,
        quantity: quantity,
      ),
    );
  }

  void pushErroDialog(
      {required BuildContext context, required Failure failure}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const TextBody(text: 'Error'),
        content: TextBody(text: failure.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const TextBody(text: 'Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BagBloc>(context).add(GetAllBagItemsEvent());
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderRow(
                pageTitle: widget.pageTitle,
                centerTitle: true,
              ),
              Expanded(
                child: BlocBuilder<BagBloc, BagState>(
                  builder: (context, state) {
                    if (state is BagInitial || state is BagEmptyState) {
                      return const EmptyView(
                        icon: CupertinoIcons.bag_fill,
                        title: 'Your bag is empty',
                        subtitle: 'Add items to your bag to continue',
                      );
                    } else if (state is BagLoadingState) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  Constants.innerPadding.copyWith(bottom: 0),
                              child: const LoadingStateWidget(height: 140),
                            );
                          },
                        ),
                      );
                    } else if (state is BagLoadedState ||
                        state is BagLoadedAddedState ||
                        state is BagLoadedRemovedState) {
                      log('state.bagItems.first.id: ${state.bagItems.first.id}');
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: state.bagItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  direction: DismissDirection.endToStart,
                                  dismissThresholds: const {
                                    DismissDirection.endToStart: 0.4,
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    child: Padding(
                                      padding: Constants.padding,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  confirmDismiss: (direction) => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const TextBody(
                                                text: 'Are you sure?'),
                                            content: const TextBody(
                                              text:
                                                  'Do you want to remove this item from your bag?',
                                              maxLines: 10,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const TextBody(
                                                  text: 'Yes',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )),
                                  key: Key(state.bagItems[index].id),
                                  onDismissed: (direction) =>
                                      BlocProvider.of<BagBloc>(context).add(
                                    RemoveBagItemEvent(bagItemIndex: index),
                                  ),
                                  child: SavedProductListTile(
                                    isOutOfStock:
                                        state.bagItems[index].isOutOfStock,
                                    title: state.bagItems[index].title,
                                    onTap: () => navigateToProductPage(
                                      state.bagItems[index].parentProductId,
                                      context,
                                    ),
                                    margin: true,
                                    imageUrl: state
                                        .bagItems[index].image?.originalSrc,
                                    subHeadings: state
                                        .bagItems[index].selectedOptions
                                        ?.map((prodOption) =>
                                            '${prodOption.name}: ${prodOption.value}')
                                        .toList(),
                                    quantity: state.bagItems[index].quantity,
                                    price: state.bagItems[index].price,
                                    onQuantitySelectorTap: () async {
                                      final resp =
                                          await showQuantitySelectorModal(
                                              context, state.bagItems[index]);
                                      if (resp != null) {
                                        if (context.mounted) {
                                          updateBagItemQuantity(
                                              state.bagItems[index],
                                              resp,
                                              context);
                                        }
                                      }
                                    },
                                  ),
                                );
                              },
                            ),

                            // Totals
                            Padding(
                              padding: Constants.padding,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextBody(
                                        text: 'Subtotal',
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                      ),
                                      TextBody(
                                        text: state.bagTotals.subtotal
                                            .formattedPrice(),
                                        color: Theme.of(context)
                                            .unselectedWidgetColor,
                                      ),
                                    ],
                                  ),
                                  const StandardSpacing(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const TextSubHeadline(
                                        text: 'Total',
                                      ),
                                      TextSubHeadline(
                                        text: state.bagTotals.total
                                            .formattedPrice(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is BagErrorState) {
                      return GestureDetector(
                        onTap: () {
                          BlocProvider.of<BagBloc>(context)
                              .add(GetAllBagItemsEvent());
                        },
                        child: IconTextError(
                          failure: state.failure,
                        ),
                      );
                    } else {
                      return IconTextError(failure: UnknownFailure());
                    }
                  },
                ),
              ),
              BlocBuilder<BagBloc, BagState>(
                builder: (context, bagState) {
                  if (bagState.bagItems.isEmpty) {
                    return const SizedBox();
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: Constants.padding,
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                checkoutBloc.add(
                                  AddToCheckoutEvent(
                                    bagItems: bagState.bagItems,
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIcon(
                                    CupertinoIcons.lock_fill,
                                    color: Theme.of(context).canvasColor,
                                  ),
                                  const StandardSpacing(
                                    horizontalAxis: true,
                                  ),
                                  TextSubHeadline(
                                    text: 'Checkout Securely',
                                    color: Theme.of(context).canvasColor,
                                  ),
                                ],
                              ),
                            ).animate().fadeIn()),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          BlocBuilder<CheckoutBloc, CheckoutState>(
            bloc: checkoutBloc,
            builder: (context, state) {
              if (state is CheckoutLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (state is CheckoutError) {
                return const SizedBox.shrink();
              } else if (state is CheckoutLoaded) {
                return WebCheckoutPage(
                  checkoutId: state.checkout.id,
                  onCanceled: () {
                    BlocProvider.of<CheckoutBloc>(context).add(
                      const CheckoutClosedEvent(),
                    );
                  },
                  onComplete: (complete) async {
                    if (!complete) {
                      return;
                    }
                    BlocProvider.of<BagBloc>(context).add(ClearBagEvent());
                    BlocProvider.of<CheckoutBloc>(context).add(
                        CheckoutCompletedEvent(checkoutId: state.checkout.id));
                  },
                ).animate().fadeIn();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
