import 'package:device_preview/device_preview.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/bloc/options_selection/options_selection_bloc.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_selected_option.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_unit_price_measurement.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/util/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shopify_flutter/shopify_config.dart';
import 'package:ecom_template/injection_container.dart' as injection;

import 'core/presentation/main_view.dart';
import 'core/presentation/state_managment/navigation_provider.dart';

void main() async {
  await initialConfig();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PageNavigationProvider>(
          create: (_) => PageNavigationProvider(),
        ),
        BlocProvider(create: (_) => injection.sl<BagBloc>()),
        BlocProvider(create: (_) => injection.sl<FavoritesBloc>()),
        BlocProvider(create: (_) => injection.sl<ShoppingBloc>()),
        BlocProvider(create: (_) => injection.sl<OptionsSelectionBloc>()),
        BlocProvider(create: (_) => injection.sl<CheckoutBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
        theme: CustomTheme.lightTheme,
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        // ignore: deprecated_member_use
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: const MainView(),
      ),
    );
  }
}

// Config
class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

Future<void> initialConfig() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  ShopifyConfig.setConfig(
    storefrontAccessToken: dotenv.env['STOREFRONT_ACCESS_TOKEN']!,
    storeUrl: dotenv.env['STORE_URL']!,
    adminAccessToken: dotenv.env['ADMIN_ACCESS_TOKEN']!,
    storefrontApiVersion: dotenv.env['STOREFRONT_API_VERSION']!,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(BagItemDataAdapter());
  Hive.registerAdapter(PriceAdapter());
  Hive.registerAdapter(ShopProductImageAdapter());
  Hive.registerAdapter(ShopProductSelectedOptionAdapter());
  Hive.registerAdapter(ShopProductUnitPriceMeasurementAdapter());
  Hive.registerAdapter(OptionsSelectionsAdapter());
  Hive.registerAdapter(FavoriteAdapter());

  await injection.init();

  // await Hive.deleteBoxFromDisk('bag');
  // await Hive.deleteBoxFromDisk('favorites');
  // await Hive.deleteBoxFromDisk('options_selection');

  // try {
  //   ShopifyCheckout shopifyCheckout = ShopifyCheckout.instance;
  //   final resp = await shopifyCheckout.createCheckout(
  //       lineItems: [
  //         LineItem(
  //             title: 'title',
  //             quantity: 2,
  //             variantId: 'gid://shopify/ProductVariant/46998324445524')
  //       ],
  //       email: 'schaekenj@gmail.com',
  //       shippingAddress: Address(
  //         address1: '34 Glencairn Lawn',
  //         address2: 'The Gallops',
  //         city: 'Leopardtown',
  //         formattedArea: 'Dublin, Leinster, Ireland',
  //         countryCode: 'IE',
  //         country: 'Ireland',
  //         firstName: 'Jacques',
  //         lastName: 'Schaeken',
  //         phone: '0035387654321',
  //         province: 'Dublin',
  //         zip: 'D18K0H3',
  //       ));
  //   print(resp);
  // } catch (e) {
  //   print(e);
  // }
}
