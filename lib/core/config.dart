import 'package:flutter/cupertino.dart';

class TabBarItemIcon {
  final TabBarItems item;
  final List<IconData> icon;

  const TabBarItemIcon({required this.item, required this.icon});
}

class IconPair {
  final IconData active;
  final IconData inactive;

  const IconPair(this.active, this.inactive);
}

// Ehanced enum with pages and their associated index
enum TabBarItems {
  explore(
      0,
      "Explore",
      IconPair(
        CupertinoIcons.square_stack_3d_down_right_fill,
        CupertinoIcons.square_stack_3d_down_right,
      )),
  shop(1, "Shop", IconPair(CupertinoIcons.house_fill, CupertinoIcons.house)),
  bag(2, "Bag", IconPair(CupertinoIcons.bag_fill, CupertinoIcons.bag)),
  favorites(3, "Favorites",
      IconPair(CupertinoIcons.heart_fill, CupertinoIcons.heart)),
  account(4, "Account",
      IconPair(CupertinoIcons.person_fill, CupertinoIcons.person));

  final int idx;
  final String name;
  final IconPair iconPairs;

  const TabBarItems(this.idx, this.name, this.iconPairs);
}
