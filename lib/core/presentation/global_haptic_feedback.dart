import 'dart:async';

import 'package:ecom_template/core/presentation/state_managment/navigation_provider.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

StreamSubscription<BagState>? setBagListerForHapticFeedback({
  required Stream<BagState> stream,
  required PageNavigationProvider pageNavigationProvider,
  required List<GlobalKey<NavigatorState>> keys,
}) {
  return stream.listen((event) {
    if (event is BagLoadedAddedState || event is BagLoadedRemovedState) {
      if (event.bagItems.isNotEmpty &&
          (pageNavigationProvider.currentIndex != 2 ||
              keys[2].currentState?.canPop() == true)) {
        HapticFeedback.mediumImpact();
      }
    }
  });
}
