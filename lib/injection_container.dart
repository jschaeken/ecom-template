import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/data/datasources/options_selection_local_datasource.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/calculate_bag_totals.dart';
import 'package:ecom_template/features/bag/domain/usecases/clear_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_all_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/option_selection_verification.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_quantity.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_fields.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/bloc/options_selection/options_selection_bloc.dart';
import 'package:ecom_template/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:ecom_template/features/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:ecom_template/features/checkout/domain/usecases/add_discount_code.dart';
import 'package:ecom_template/features/checkout/domain/usecases/bag_items_to_line_items.dart';
import 'package:ecom_template/features/checkout/domain/usecases/create_checkout.dart';
import 'package:ecom_template/features/checkout/domain/usecases/get_checkout_info.dart';
import 'package:ecom_template/features/checkout/domain/usecases/remove_discount_code.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_info_datasource.dart';
import 'package:ecom_template/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:ecom_template/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ecom_template/features/favorites/domain/usecases/add_favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/get_favorite_by_id.dart';
import 'package:ecom_template/features/favorites/domain/usecases/get_favorites.dart';
import 'package:ecom_template/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/order/data/datasources/orders_remote_datasource.dart';
import 'package:ecom_template/features/order/data/repositories/orders_repository_impl.dart';
import 'package:ecom_template/features/order/domain/repositories/orders_repository.dart';
import 'package:ecom_template/features/order/domain/usecases/get_all_orders.dart';
import 'package:ecom_template/features/order/presentation/bloc/orders_bloc.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/data/repositories/product_repositoty_impl.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_collections.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products_by_collection_id.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_products_by_list_ids.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_products_by_substring.dart';
import 'package:ecom_template/features/shop/presentation/bloc/collections_view/collections_view_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/searching/searching_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shopify_flutter/shopify/shopify.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  /// Features ///

  /// Shop ///
  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(shopifyStore: sl()),
  );
  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImplementation(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Use Cases
  sl.registerLazySingleton(() => GetAllProducts(repository: sl()));
  sl.registerLazySingleton(() => GetProductById(repository: sl()));
  sl.registerLazySingleton(() => GetAllCollections(repository: sl()));
  sl.registerLazySingleton(
      () => GetAllProductsByCollectionId(repository: sl()));
  sl.registerLazySingleton(() => GetProductsBySubstring(repository: sl()));
  sl.registerLazySingleton(() => GetProductsByListIds(repository: sl()));
  // Blocs
  sl.registerFactory(
    () => ShoppingBloc(
      getAllProducts: sl(),
      getProductById: sl(),
      getAllProductsByCollectionId: sl(),
      getProductsByListIds: sl(),
    ),
  );
  sl.registerFactory(
    () => CollectionsViewBloc(
      getAllCollections: sl(),
    ),
  );
  sl.registerFactory(
    () => SearchingBloc(
      getProductsBySubstring: sl(),
    ),
  );

  /// Bag ///
  // Data Sources
  sl.registerLazySingleton<BagItemsLocalDataSource>(
    () => BagItemsLocalDataSourceImpl(interface: sl()),
  );
  // Repositories
  sl.registerLazySingleton<BagRepository>(
    () => BagRepositoryImpl(
      bagItemsDataSource: sl(),
      optionsSelectionDataSource: sl(),
      productRemoteDataSource: sl(),
    ),
  );
  // Use Cases
  sl.registerLazySingleton(() => AddBagItem(repository: sl()));
  sl.registerLazySingleton(() => RemoveBagItem(repository: sl()));
  sl.registerLazySingleton(() => GetAllBagItems(repository: sl()));
  sl.registerLazySingleton(() => UpdateBagItem(repository: sl()));
  sl.registerLazySingleton(() => ClearBagItems(repository: sl()));
  sl.registerLazySingleton(() => CalculateBagTotals());
  // Blocs
  sl.registerLazySingleton(
    () => BagBloc(
      addBagItem: sl(),
      removeBagItem: sl(),
      getAllBagItems: sl(),
      checkoutBloc: sl(),
      clearBagItems: sl(),
      updateBagItem: sl(),
      calculateBagTotals: sl(),
    ),
  );

  /// Favorites ///
  // Data Sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(interface: sl()),
  );
  // Repositories
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  // Use Cases
  sl.registerLazySingleton(() => AddFavorite(repository: sl()));
  sl.registerLazySingleton(() => RemoveFavorite(repository: sl()));
  sl.registerLazySingleton(() => GetFavorites(repository: sl()));
  sl.registerLazySingleton(() => GetFavoriteById(repository: sl()));
  // Blocs
  sl.registerFactory(
    () => FavoritesBloc(
      addFavoriteUseCase: sl(),
      removeFavoriteUseCase: sl(),
      getFavoritesUseCase: sl(),
      getProductById: sl(),
      getFavoriteUseCase: sl(),
    ),
  );

  /// Options Selection ///
  // Data Sources
  sl.registerLazySingleton<OptionsSelectionDataSource>(
    () => OptionsSelectionDataSourceImpl(interface: sl()),
  );
  // Repositories
  /* Uses Bag Item Repository */
  // Use Cases
  sl.registerLazySingleton(() => GetSavedSelectedOptions(repository: sl()));
  sl.registerLazySingleton(() => UpdateSelectedOptionsFields(repository: sl()));
  sl.registerLazySingleton(
      () => UpdateSelectedOptionsQuantity(repository: sl()));
  sl.registerLazySingleton(() => VerifyOptions());
  // Blocs
  sl.registerFactory(() => OptionsSelectionBloc(
        getSavedSelectedOptions: sl(),
        updateSelectedOptionsQuantity: sl(),
        updateSelectedOptionsFields: sl(),
        verifyOptions: sl(),
      ));

  /// Checkout ///
  // Data Sources
  sl.registerLazySingleton<CheckoutRemoteDataSource>(
      () => CheckoutRemoteDataSourceImpl(shopifyCheckout: sl()));
  // Repositories
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      dataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Use Cases
  sl.registerLazySingleton(() => CreateCheckout(repository: sl()));
  sl.registerLazySingleton(() => GetCheckoutInfo(repository: sl()));
  sl.registerLazySingleton(() => AddDiscountCode(repository: sl()));
  sl.registerLazySingleton(() => RemoveDiscountCode(repository: sl()));
  sl.registerLazySingleton(() => BagItemsToLineItems());
  // Blocs
  sl.registerFactory(() => CheckoutBloc(
        createCheckout: sl(),
        getCheckoutInfo: sl(),
        bagItemsToLineItems: sl(),
        addDiscountCode: sl(),
        removeDiscountCode: sl(),
      ));

  /// Orders ///
  // Data Sources
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(shopifyCheckout: sl()),
  );
  // Repositories
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(
      customerInfoDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // Use Cases
  sl.registerLazySingleton(() => GetAllOrders(repository: sl()));
  // Blocs
  sl.registerFactory(
    () => OrdersBloc(
      getAllOrders: sl(),
    ),
  );

  /// Customer ///
  // Data Sources
  sl.registerLazySingleton<CustomerInfoDataSource>(
    () => CustomerInfoDataSourceImpl(interface: sl()),
  );

  /// Core ///
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /// External ///
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => ShopifyStore.instance);
  sl.registerLazySingleton(() => ShopifyCheckout.instance);
  sl.registerLazySingleton(() => Hive);
}
