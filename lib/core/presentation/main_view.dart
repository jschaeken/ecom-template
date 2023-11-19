import 'dart:async';

import 'package:ecom_template/core/config.dart';
import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/state_managment/navigation_provider.dart';
import 'package:ecom_template/core/presentation/widgets/noti_icon.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/pages/bag_page.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/pages/checkout_modal.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/favorites/presentation/pages/favorites_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/explore_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/shop_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<TabBarItem> tabBarItems = Config.tabBarItems;
  late List<GlobalKey<NavigatorState>> keys;
  StreamSubscription<BagState>? bagStreamSubscription;

  final List<Widget> tabBarPages = [
    ExplorePage(pageTitle: 'EXPLORE'),
    const ShopPage(pageTitle: 'SHOP'),
    const BagPage(pageTitle: 'BAG'),
    const FavoritesPage(title: 'FAVORITES'),
    // TODO: Add Account Page
    const Scaffold(
      body: Center(
        child: TextBody(text: 'Account Page'),
      ),
    )
  ];

  void setBagListerForHapticFeedback(Stream<BagState> stream) {
    bagStreamSubscription = stream.listen((event) {
      if (event is BagLoadedAddedState || event is BagLoadedRemovedState) {
        if (event.bagItems.isNotEmpty &&
            (context.read<PageNavigationProvider>().currentIndex != 2 ||
                keys[2].currentState?.canPop() == true)) {
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: Constants.borderRadius,
              ),
              elevation: 10,
              content: TextBody(
                text: event.runtimeType == BagLoadedAddedState
                    ? 'Added to Bag'
                    : 'Removed from Bag',
              ),
              action: SnackBarAction(
                  label: 'View Bag',
                  onPressed: () {
                    context.read<PageNavigationProvider>().changeIndex(2);
                    keys[2].currentState?.popUntil((route) => route.isFirst);
                  }),
            ),
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    keys = tabBarPages.map((page) => GlobalKey<NavigatorState>()).toList();
    setBagListerForHapticFeedback(BlocProvider.of<BagBloc>(context).stream);
  }

  @override
  dispose() {
    bagStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, checkoutState) {
        return Stack(
          children: [
            Scaffold(
              body: SafeArea(
                child: IndexedStack(
                  index: context.watch<PageNavigationProvider>().currentIndex,
                  children: [
                    ...tabBarPages.map(
                      (page) => OffstageNavigator(
                        index: tabBarPages.indexOf(page),
                        navKey: keys[tabBarPages.indexOf(page)],
                        child: page,
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: tabBarItems.map((item) {
                  return BottomNavigationBarItem(
                    icon: item.title == 'Bag'
                        ? BagNotiIcon(iconData: item.icon[0])
                        : item.title == 'Favorites'
                            ? FavoritesNotiIcon(iconData: item.icon[0])
                            : Icon(item.icon[0]),
                    activeIcon: Icon(item.icon[1]),
                    label: item.title,
                  );
                }).toList(),
                currentIndex:
                    context.watch<PageNavigationProvider>().currentIndex,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor:
                    Theme.of(context).primaryColor.withOpacity(0.5),
                showUnselectedLabels: false,
                showSelectedLabels: false,
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  if (value ==
                      context.read<PageNavigationProvider>().currentIndex) {
                    keys[value]
                        .currentState
                        ?.popUntil((route) => route.isFirst);
                  } else {
                    context.read<PageNavigationProvider>().changeIndex(value);
                  }
                },
              ),
            ),
            Builder(builder: (context) {
              switch (checkoutState.runtimeType) {
                case CheckoutInitial:
                  return const SizedBox.shrink();
                case CheckoutLoading || CheckoutLoaded || CheckoutError:
                  return CheckoutModal(
                    onClosed: () {
                      context.read<CheckoutBloc>().add(
                            const CheckoutClosedEvent(),
                          );
                    },
                  );
                default:
                  return const SizedBox.shrink();
              }
            }),
          ],
        );
      },
    );
  }
}

class FavoritesNotiIcon extends StatelessWidget {
  final IconData iconData;
  const FavoritesNotiIcon({
    super.key,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if ((state is FavoritesAddedLoaded ||
                state is FavoritesRemovedLoaded ||
                state is FavoritesLoaded) &&
            state.favorites.isNotEmpty) {
          return NotiIcon(
            icon: iconData,
            visible: true,
            isUnder: true,
          );
        } else {
          return NotiIcon(
            icon: iconData,
            visible: false,
          );
        }
      },
    );
  }
}

class BagNotiIcon extends StatelessWidget {
  final IconData iconData;
  const BagNotiIcon({
    super.key,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BagBloc, BagState>(
      builder: (context, state) {
        if ((state is BagLoadedState ||
                state is BagLoadedAddedState ||
                state is BagLoadedRemovedState) &&
            state.bagItems.isNotEmpty) {
          return NotiIcon(
            isUnder: false,
            icon: iconData,
            visible: true,
            text: state.bagItems.length.toString(),
          );
        } else {
          return NotiIcon(
            icon: iconData,
            visible: false,
          );
        }
      },
    );
  }
}

class OffstageNavigator extends StatelessWidget {
  const OffstageNavigator(
      {required this.child,
      required this.index,
      required this.navKey,
      super.key});

  final Widget child;
  final int index;
  final GlobalKey<NavigatorState> navKey;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: context.watch<PageNavigationProvider>().currentIndex != index,
      child: Navigator(
        key: navKey,
        onGenerateRoute: (routeSettings) {
          return CupertinoPageRoute(
            builder: (context) => child,
          );
        },
      ),
    );
  }
}
