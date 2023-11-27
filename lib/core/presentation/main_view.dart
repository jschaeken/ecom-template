import 'dart:async';
import 'dart:developer';

import 'package:ecom_template/core/config.dart';
import 'package:ecom_template/core/presentation/global_haptic_feedback.dart';
import 'package:ecom_template/core/presentation/checkout_listeners.dart';
import 'package:ecom_template/core/presentation/page_not_found.dart';
import 'package:ecom_template/core/presentation/state_managment/navigation_provider.dart';
import 'package:ecom_template/core/presentation/widgets/noti_icon.dart';
import 'package:ecom_template/features/customer/presentation/pages/account_page.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/pages/bag_page.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/pages/checkout_modal.dart';
import 'package:ecom_template/features/favorites/presentation/pages/favorites_page.dart';
import 'package:ecom_template/features/order/domain/entities/order_completion.dart';
import 'package:ecom_template/features/order/presentation/pages/orders_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/explore_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/shop_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<TabBarItem> tabBarItems = Config.tabBarItems;
  late List<GlobalKey<NavigatorState>> keys;
  StreamSubscription<BagState>? bagHapticStreamSubscription;
  StreamSubscription<CheckoutState>? checkoutStreamSubscription;

  final List<Widget> tabBarPages = [
    ExplorePage(pageTitle: 'EXPLORE'),
    const ShopPage(pageTitle: 'SHOP'),
    const BagPage(pageTitle: 'BAG'),
    FavoritesPage(pageTitle: 'FAVORITES'),
    AccountPage(pageTitle: 'ACCOUNT'),
  ];

  @override
  void initState() {
    super.initState();
    keys = tabBarPages.map((page) => GlobalKey<NavigatorState>()).toList();
    bagHapticStreamSubscription = setBagListerForHapticFeedback(
      keys: keys,
      pageNavigationProvider: context.read<PageNavigationProvider>(),
      stream: BlocProvider.of<BagBloc>(context).stream,
    );
    checkoutStreamSubscription = setCheckoutListerOrderCompletePopUp(
      stream: BlocProvider.of<CheckoutBloc>(context).stream,
      context: context,
    );
  }

  @override
  dispose() {
    bagHapticStreamSubscription?.cancel();
    checkoutStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutBloc, CheckoutState>(
      builder: (context, checkoutState) {
        return Scaffold(
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
            currentIndex: context.watch<PageNavigationProvider>().currentIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor:
                Theme.of(context).primaryColor.withOpacity(0.5),
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              if (value ==
                  context.read<PageNavigationProvider>().currentIndex) {
                keys[value].currentState?.popUntil((route) => route.isFirst);
              } else {
                context.read<PageNavigationProvider>().changeIndex(value);
              }
            },
          ),
        );
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
        onUnknownRoute: (routeSettings) {
          return CupertinoPageRoute(
            builder: (context) => const PageNotFound(),
          );
        },
        onGenerateRoute: (routeSettings) {
          switch (routeSettings.name) {
            // Add named routes here
            case '/explore':
              return CupertinoPageRoute(
                builder: (context) => ExplorePage(
                  pageTitle: 'EXPLORE',
                ),
              );
            case '/account':
              return CupertinoPageRoute(
                builder: (context) => AccountPage(
                  pageTitle: 'ACCOUNT',
                ),
              );
            case '/orders':
              return CupertinoPageRoute(
                builder: (context) => const OrdersPage(),
              );
            default:
              return CupertinoPageRoute(
                builder: (context) => child,
              );
          }
        },
      ),
    );
  }
}
