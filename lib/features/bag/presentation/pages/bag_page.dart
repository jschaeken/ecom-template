import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/widgets/quantity_selector.dart';
import 'package:ecom_template/features/shop/presentation/pages/product_page.dart';
import 'package:ecom_template/features/shop/presentation/widgets/empty_view.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BagPage extends StatelessWidget {
  const BagPage({super.key, required this.pageTitle});

  final String pageTitle;

  void navigateToProductPage(String productId, BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => ProductPage(
                id: productId,
              )),
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

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<BagBloc>(context).add(GetAllBagItemsEvent());
    return Scaffold(
      body: Column(
        children: [
          HeaderRow(
            pageTitle: pageTitle,
            accountInitials: 'JS',
            centerTitle: true,
          ),
          Expanded(
            child: BlocBuilder<BagBloc, BagState>(
              builder: (context, state) {
                if (state is BagInitial || state is BagEmptyState) {
                  return const Expanded(
                    child: EmptyView(
                      icon: CupertinoIcons.bag_fill,
                      title: 'Your bag is empty',
                      subtitle: 'Add items to your bag to continue',
                    ),
                  );
                } else if (state is BagLoadingState) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: Constants.innerPadding.copyWith(bottom: 0),
                          child: const LoadingStateWidget(height: 140),
                        );
                      },
                    ),
                  );
                } else if (state is BagLoadedState ||
                    state is BagLoadedAddedState ||
                    state is BagLoadedRemovedState) {
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
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                        title: const Text('Are you sure?'),
                                        content: const Text(
                                            'Do you want to remove this item from your bag?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const TextBody(
                                                text: 'Yes',
                                              )),
                                        ],
                                      )),
                              key: Key(state.bagItems[index].id),
                              onDismissed: (direction) =>
                                  BlocProvider.of<BagBloc>(context).add(
                                RemoveBagItemEvent(
                                  bagItem: state.bagItems[index],
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () => navigateToProductPage(
                                    state.bagItems[index].parentProductId,
                                    context),
                                child: Card(
                                    color: Theme.of(context).canvasColor,
                                    child: Padding(
                                      padding: Constants.padding,
                                      child: SizedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Image
                                            Container(
                                              width: 100,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                image: state.bagItems[index]
                                                            .image ==
                                                        null
                                                    ? const DecorationImage(
                                                        image: AssetImage(
                                                          'assets/images/placeholder-image.png',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : DecorationImage(
                                                        image: NetworkImage(
                                                          state
                                                              .bagItems[index]
                                                              .image!
                                                              .originalSrc,
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
                                                constraints:
                                                    const BoxConstraints(
                                                  minHeight: 120,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    // Title
                                                    const TextBody(
                                                        text:
                                                            'TODO: Implement Product Title to Bag'),
                                                    const StandardSpacing(),

                                                    // Selected Options
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: state
                                                              .bagItems[index]
                                                              .selectedOptions
                                                              ?.length ??
                                                          0,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return Padding(
                                                          padding: Constants
                                                              .padding
                                                              .copyWith(
                                                                  left: 0,
                                                                  right: 0,
                                                                  top: 0),
                                                          child: TextBody(
                                                            text:
                                                                '${state.bagItems[index].selectedOptions?[i].name}: ${state.bagItems[index].selectedOptions?[i].value}',
                                                            color: Theme.of(
                                                                    context)
                                                                .unselectedWidgetColor,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    // Price and Quantity Row
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextSubHeadline(
                                                          text: state
                                                              .bagItems[index]
                                                              .price
                                                              .toString(),
                                                        ),
                                                        QuantitySelectorButton(
                                                          quantity: state
                                                              .bagItems[index]
                                                              .quantity,
                                                          onTap: () async {
                                                            final resp =
                                                                await showQuantitySelectorModal(
                                                                    context,
                                                                    state.bagItems[
                                                                        index]);
                                                            if (resp != null) {
                                                              if (context
                                                                  .mounted) {
                                                                updateBagItemQuantity(
                                                                    state.bagItems[
                                                                        index],
                                                                    resp,
                                                                    context);
                                                              }
                                                            }
                                                          },
                                                        )
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
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                  ),
                                  TextBody(
                                    text: 'Free',
                                    color:
                                        Theme.of(context).unselectedWidgetColor,
                                  ),
                                ],
                              ),
                              const StandardSpacing(),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextSubHeadline(
                                    text: 'Total',
                                  ),
                                  TextSubHeadline(
                                    text: 'Free',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Spacing
                        const StandardSpacing(multiplier: 10),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
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
              onPressed: () {},
              child: TextBody(
                text: 'Checkout',
                color: Theme.of(context).canvasColor,
              ),
            ).animate().scaleXY(
                  begin: 0,
                )),
      ),
    );
  }
}
