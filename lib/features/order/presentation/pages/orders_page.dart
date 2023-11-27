import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/featured_brand_tile.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/safe_image.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/checkout/domain/entities/product_variant_checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/order/domain/entities/discount_allocations.dart';
import 'package:ecom_template/features/order/domain/entities/line_item_order.dart';
import 'package:ecom_template/features/order/domain/entities/line_items_order.dart';
import 'package:ecom_template/features/order/domain/entities/order.dart';
import 'package:ecom_template/features/order/domain/entities/successful_fulfilment.dart';
import 'package:ecom_template/features/order/domain/entities/successful_fulfilment_tracking_info.dart';
import 'package:ecom_template/features/order/presentation/bloc/orders_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  // final testOrders = const [
  //   ShopOrder(
  //     billingAddress: ShopShippingAddress(
  //       firstName: 'firstName',
  //       lastName: 'lastName',
  //       name: 'firstName lastName',
  //       id: 'id',
  //       address1: 'address1',
  //       city: 'city',
  //       country: 'country',
  //       zip: 'zip',
  //       address2: 'address2',
  //       company: 'company',
  //       countryCodeV2: 'countryCodeV2',
  //       formattedArea: 'formattedArea',
  //       latitude: 1,
  //       longitude: 1,
  //       phone: 'phone',
  //       province: 'province',
  //       provinceCode: 'provinceCode',
  //     ),
  //     customerUrl: 'customerUrl',
  //     fulfillmentStatus: 'Shipped',
  //     shippingAddress: ShopShippingAddress(
  //       firstName: 'firstName',
  //       lastName: 'lastName',
  //       name: 'firstName lastName',
  //       id: 'id',
  //       address1: 'address1',
  //       city: 'city',
  //       country: 'country',
  //       zip: 'zip',
  //       address2: 'address2',
  //       company: 'company',
  //       countryCodeV2: 'countryCodeV2',
  //       formattedArea: 'formattedArea',
  //       latitude: 1,
  //       longitude: 1,
  //       phone: 'phone',
  //       province: 'province',
  //       provinceCode: 'provinceCode',
  //     ),
  //     statusUrl: 'statusUrl',
  //     cursor: 'cursor',
  //     successfulFulfillments: [
  //       ShopSuccessfulFulfilment(
  //         trackingInfo: [
  //           ShopSuccessfulFulfilmentTrackingInfo(
  //             number: 'TR4CK1NGNUMB3R',
  //             url: 'url',
  //           ),
  //         ],
  //         trackingCompany: 'An Post',
  //       ),
  //     ],
  //     id: 'id',
  //     orderNumber: 18765,
  //     processedAt: 'processedAt',
  //     totalPrice: Price(amount: 1, currencyCode: 'USD'),
  //     totalRefunded: Price(amount: 2, currencyCode: 'EUR'),
  //     totalShippingPrice: Price(amount: 3, currencyCode: 'YEN'),
  //     subtotalPrice: Price(amount: 4, currencyCode: 'CAD'),
  //     totalTax: Price(amount: 5, currencyCode: 'CHZ'),
  //     currencyCode: 'currencyCode',
  //     financialStatus: 'financialStatus',
  //     email: 'email',
  //     phone: 'phone',
  //     name: 'name',
  //     lineItems: ShopLineItemsOrder(
  //       lineItemOrderList: [
  //         ShopLineItemOrder(
  //           currentQuantity: 1,
  //           discountAllocations: [
  //             ShopDiscountAllocations(
  //               allocatedAmount: Price(amount: 0, currencyCode: 'EUR'),
  //             ),
  //           ],
  //           discountedTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           originalTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           quantity: 1,
  //           title: 'title',
  //           variant: ShopProductVariantCheckout(
  //             availableForSale: true,
  //             compareAtPrice: Price(amount: 40, currencyCode: 'EUR'),
  //             image: ShopProductImage(
  //                 altText: 'altText',
  //                 id: 'id',
  //                 originalSrc:
  //                     'https://m.media-amazon.com/images/I/51Baf5VNqDL._AC_SX679_.jpg'),
  //             product: null,
  //             quantityAvailable: 10,
  //             requiresShipping: true,
  //             weight: 10,
  //             weightUnit: 'Kg',
  //             id: 'id',
  //             title: 'title',
  //             sku: 'SkuNum',
  //             price: Price(amount: 10, currencyCode: 'EUR'),
  //           ),
  //         ),
  //         ShopLineItemOrder(
  //           currentQuantity: 1,
  //           discountAllocations: [
  //             ShopDiscountAllocations(
  //               allocatedAmount: Price(amount: 0, currencyCode: 'EUR'),
  //             ),
  //           ],
  //           discountedTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           originalTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           quantity: 1,
  //           title: 'title',
  //           variant: ShopProductVariantCheckout(
  //             availableForSale: true,
  //             compareAtPrice: Price(amount: 40, currencyCode: 'EUR'),
  //             image: ShopProductImage(
  //                 altText: 'altText',
  //                 id: 'id',
  //                 originalSrc:
  //                     'https://m.media-amazon.com/images/I/51Baf5VNqDL._AC_SX679_.jpg'),
  //             product: null,
  //             quantityAvailable: 10,
  //             requiresShipping: true,
  //             weight: 10,
  //             weightUnit: 'Kg',
  //             id: 'id',
  //             title: 'title',
  //             sku: 'SkuNum',
  //             price: Price(amount: 10, currencyCode: 'EUR'),
  //           ),
  //         ),
  //         ShopLineItemOrder(
  //           currentQuantity: 1,
  //           discountAllocations: [
  //             ShopDiscountAllocations(
  //               allocatedAmount: Price(amount: 0, currencyCode: 'EUR'),
  //             ),
  //           ],
  //           discountedTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           originalTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           quantity: 1,
  //           title: 'title',
  //           variant: ShopProductVariantCheckout(
  //             availableForSale: true,
  //             compareAtPrice: Price(amount: 40, currencyCode: 'EUR'),
  //             image: ShopProductImage(
  //                 altText: 'altText',
  //                 id: 'id',
  //                 originalSrc:
  //                     'https://m.media-amazon.com/images/I/51Baf5VNqDL._AC_SX679_.jpg'),
  //             product: null,
  //             quantityAvailable: 10,
  //             requiresShipping: true,
  //             weight: 10,
  //             weightUnit: 'Kg',
  //             id: 'id',
  //             title: 'title',
  //             sku: 'SkuNum',
  //             price: Price(amount: 10, currencyCode: 'EUR'),
  //           ),
  //         ),
  //         ShopLineItemOrder(
  //           currentQuantity: 1,
  //           discountAllocations: [
  //             ShopDiscountAllocations(
  //               allocatedAmount: Price(amount: 0, currencyCode: 'EUR'),
  //             ),
  //           ],
  //           discountedTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           originalTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           quantity: 1,
  //           title: 'title',
  //           variant: ShopProductVariantCheckout(
  //             availableForSale: true,
  //             compareAtPrice: Price(amount: 40, currencyCode: 'EUR'),
  //             image: ShopProductImage(
  //               altText: 'altText',
  //               id: 'id',
  //               originalSrc:
  //                   'https://m.media-amazon.com/images/I/51Baf5VNqDL._AC_SX679_.jpg',
  //             ),
  //             product: null,
  //             quantityAvailable: 10,
  //             requiresShipping: true,
  //             weight: 10,
  //             weightUnit: 'Kg',
  //             id: 'id',
  //             title: 'title',
  //             sku: 'SkuNum',
  //             price: Price(amount: 10, currencyCode: 'EUR'),
  //           ),
  //         ),
  //         ShopLineItemOrder(
  //           currentQuantity: 1,
  //           discountAllocations: [
  //             ShopDiscountAllocations(
  //               allocatedAmount: Price(amount: 0, currencyCode: 'EUR'),
  //             ),
  //           ],
  //           discountedTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           originalTotalPrice: Price(amount: 0, currencyCode: 'EUR'),
  //           quantity: 1,
  //           title: 'title',
  //           variant: ShopProductVariantCheckout(
  //             availableForSale: true,
  //             compareAtPrice: Price(amount: 40, currencyCode: 'EUR'),
  //             image: ShopProductImage(
  //                 altText: 'altText',
  //                 id: 'id',
  //                 originalSrc:
  //                     'https://m.media-amazon.com/images/I/51Baf5VNqDL._AC_SX679_.jpg'),
  //             product: null,
  //             quantityAvailable: 10,
  //             requiresShipping: true,
  //             weight: 10,
  //             weightUnit: 'Kg',
  //             id: 'id',
  //             title: 'title',
  //             sku: 'SkuNum',
  //             price: Price(amount: 10, currencyCode: 'EUR'),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<OrdersBloc>(context).add(const GetAllOrdersEvent());
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Orders'),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            BlocProvider.of<OrdersBloc>(context).add(const GetAllOrdersEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<OrdersBloc, OrdersState>(
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        case OrdersInitial:
                          return const SizedBox();
                        case OrdersLoading:
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        case OrdersLoaded:
                          state as OrdersLoaded;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.orders.length,
                            itemBuilder: (context, index) {
                              final order = state.orders[index];
                              return Padding(
                                padding: Constants.padding,
                                child: Card(
                                    color: Theme.of(context).cardColor,
                                    child: Padding(
                                      padding: Constants.padding,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Order Number
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                flex: 7,
                                                child: TextSubHeadline(
                                                  text:
                                                      'Order ${order.orderNumber.toString()}',
                                                  maxLines: 1,
                                                ),
                                              ),
                                              const Flexible(
                                                flex: 1,
                                                child: CustomIcon(
                                                  CupertinoIcons.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Order Status
                                          TextBody(
                                            text: order.fulfillmentStatus,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),

                                          // Progress Bar
                                          const SizedBox(height: 10),
                                          LinearProgressIndicator(
                                              borderRadius:
                                                  Constants.borderRadius,
                                              value: 0.5,
                                              backgroundColor: Theme.of(context)
                                                  .unselectedWidgetColor,
                                              color: Theme.of(context)
                                                  .indicatorColor),

                                          const StandardSpacing(),
                                          SizedBox(
                                            height: 100,
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              itemCount: order.lineItems
                                                  .lineItemOrderList.length,
                                              scrollDirection: Axis.horizontal,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1,
                                                childAspectRatio: 1,
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing:
                                                    Constants.padding.right,
                                              ),
                                              itemBuilder: (context, index) {
                                                final lineItem = order.lineItems
                                                    .lineItemOrderList[index];
                                                return ClipRRect(
                                                  borderRadius:
                                                      Constants.borderRadius,
                                                  child: SafeImage(
                                                    imageUrl: lineItem.variant
                                                        ?.image?.originalSrc,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            },
                          );
                        case OrdersError:
                          state as OrdersError;
                          return Center(
                            child: TextBody(
                                text: 'Error: ${state.failure.toString()}'),
                          );
                        default:
                          return const Center(
                            child: TextBody(text: 'Default'),
                          );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
