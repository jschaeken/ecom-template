import 'package:ecom_template/features/shop/presentation/pages/explore_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class Constants {
  static EdgeInsets padding = const EdgeInsets.all(12);

  static BorderRadius borderRadius = BorderRadius.circular(8);

  static EdgeInsets innerPadding = const EdgeInsets.all(3);

  static List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  static String placeholderImagePath = 'assets/images/placeholder-image.png';

  static String OPTIONS_BOX_NAME = 'options_selection';

  static String BAG_BOX_NAME = 'bag_items';

  static String FAVORITES_BOX_NAME = 'favorites';

  static String ORDERS_BOX_NAME = 'orders';
}
