import 'dart:async';

import 'package:ecom_template/core/config.dart';
import 'package:ecom_template/core/presentation/state_managment/navigation_provider.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/widgets/bag_event_snackbars.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:flutter/material.dart';

StreamSubscription<BagState>? setBagListerForPopUp({
  required Stream<BagState> stream,
  required PageNavigationProvider pageNavigationProvider,
  required List<GlobalKey<NavigatorState>> keys,
  required BuildContext context,
  required CheckoutBloc checkoutBloc,
}) {
  return stream.listen((event) {
    if (event is BagLoadedAddedState) {
      if (event.bagItems.isNotEmpty) {
        debugPrint('bagItems: ${event.bagItems.map((e) => '${e.price}')}');
        showAddedToBagModal(
          context: context,
          bagItem: event.lastAddedItem,
          onCheckoutTap: () {
            pageNavigationProvider.changeIndex(TabBarItems.bag.idx);
            checkoutBloc.add(
              AddToCheckoutEvent(
                bagItems: event.bagItems,
                email: 'none',
                shippingAddress: const ShopShippingAddress(
                  id: null,
                  address1: null,
                  city: null,
                  country: null,
                  zip: null,
                  firstName: null,
                  lastName: null,
                  name: null,
                ),
              ),
            );
          },
        );
      }
    } else if (event is BagLoadedRemovedState) {
      if (event.bagItems.isNotEmpty) {
        showRemovedFromBagSnackBar(
          context: context,
          onTap: () {
            pageNavigationProvider.changeIndex(TabBarItems.bag.idx);
            // keys[TabBarItems.bag.idx].currentState!.popUntil((route) => false);
          },
        );
      }
    }
  });
}
