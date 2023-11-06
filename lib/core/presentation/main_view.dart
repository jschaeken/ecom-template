import 'dart:async';

import 'package:ecom_template/core/config.dart';
import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/state_managment/navigation_provider.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/pages/bag_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/explore_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/favorites_page.dart';
import 'package:ecom_template/features/shop/presentation/pages/shop_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    const FavoritesPage(pageTitle: 'FAVORITES'),
    // const AccountPage(pageTitle: 'ACCOUNT'),
    const Center(
      child: Text('Account Page'),
    )
  ];

  void setBagListerForHapticFeedback(Stream<BagState> stream) {
    bagStreamSubscription = stream.listen((event) {
      HapticFeedback.selectionClick();
      debugPrint('Click!');
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
        items: tabBarItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: item.title == 'Bag'
                    ? NotiIcon(icon: item.icon[0])
                    : Icon(item.icon[0]),
                activeIcon: Icon(item.icon[1]),
                label: item.title,
              ),
            )
            .toList(),
        currentIndex: context.watch<PageNavigationProvider>().currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.5),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          context.read<PageNavigationProvider>().changeIndex(value);
        },
      ),
    );
  }
}

class NotiIcon extends StatelessWidget {
  final IconData icon;

  const NotiIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
          size: 24,
        ),
        BlocBuilder<BagBloc, BagState>(
          builder: (context, state) {
            if (state is BagLoadedState && state.bagItems.isNotEmpty) {
              return Positioned(
                right: 0,
                child: Container(
                  padding: Constants.innerPadding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: TextBody(
                      text: state.bagItems.length.toString(),
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ).animate().scaleXY(
                      curve: Curves.bounceOut,
                    ),
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ],
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
