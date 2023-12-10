import 'dart:async';

import 'package:ecom_template/core/config.dart';
import 'package:ecom_template/core/presentation/state_managment/navigation_provider.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/widgets/bag_event_snackbars.dart';
import 'package:flutter/material.dart';

StreamSubscription<BagState>? setBagListerForPopUp({
  required Stream<BagState> stream,
  required PageNavigationProvider pageNavigationProvider,
  required List<GlobalKey<NavigatorState>> keys,
  required BuildContext context,
}) {
  return stream.listen((event) {
    if (event is BagLoadedAddedState) {
      if (event.bagItems.isNotEmpty) {
        showAddedToBagSnackBar(
          context: context,
          bagItem: event.bagItems.last,
          onTap: () {
            pageNavigationProvider.changeIndex(TabBarItems.bag.idx);
            // keys[TabBarItems.bag.idx].currentState!.popUntil((route) => false);
          },
        );
      }
    } else if (event is BagLoadedRemovedState) {
      if (event.bagItems.isNotEmpty) {
        showRemovedFromBagSnackBar(
          context: context,
          bagItem: event.bagItems.last,
          onTap: () {
            pageNavigationProvider.changeIndex(TabBarItems.bag.idx);
            // keys[TabBarItems.bag.idx].currentState!.popUntil((route) => false);
          },
        );
      }
    }
  });
}
