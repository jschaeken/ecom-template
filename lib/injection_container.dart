import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/bag/data/datasources/bag_items_local_datasource.dart';
import 'package:ecom_template/features/bag/data/datasources/options_selection_local_datasource.dart';
import 'package:ecom_template/features/bag/data/repositories/bag_repository_impl.dart';
import 'package:ecom_template/features/bag/domain/repositories/bag_repository.dart';
import 'package:ecom_template/features/bag/domain/usecases/add_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_all_bag_items.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/option_selection_verification.dart';
import 'package:ecom_template/features/bag/domain/usecases/remove_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_bag_item.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_quantity.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_fields.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/bag/presentation/bloc/options_selection/options_selection_bloc.dart';
import 'package:ecom_template/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:ecom_template/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:ecom_template/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:ecom_template/features/favorites/domain/usecases/add_favorite.dart';
import 'package:ecom_template/features/favorites/domain/usecases/get_favorites.dart';
import 'package:ecom_template/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/data/repositories/product_repositoty_impl.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_collections.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products_by_collection_id.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:ecom_template/features/shop/presentation/bloc/collections_view/collections_view_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shopify_flutter/shopify/src/shopify_store.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  /// Features - Shop - Shopping Bloc
  sl.registerFactory(
    () => ShoppingBloc(
      getAllProducts: sl(),
      getProductById: sl(),
      getAllProductsByCollectionId: sl(),
    ),
  );
  // Product Page - Options Selection Bloc
  sl.registerFactory(() => OptionsSelectionBloc(
        getSavedSelectedOptions: sl(),
        updateSelectedOptionsQuantity: sl(),
        updateSelectedOptionsFields: sl(),
        verifyOptions: sl(),
      ));

  /// Features - Shop - Collections Bloc
  sl.registerFactory(
    () => CollectionsViewBloc(
      getAllCollections: sl(),
    ),
  );

  /// Features - Bag - Bag Bloc
  sl.registerFactory(
    () => BagBloc(
      addBagItem: sl(),
      removeBagItem: sl(),
      getAllBagItems: sl(),
      updateBagItem: sl(),
    ),
  );

  /// Features - Favorites - Favorites Bloc
  sl.registerFactory(
    () => FavoritesBloc(
      addFavoriteUseCase: sl(),
      removeFavoriteUseCase: sl(),
      getFavoritesUseCase: sl(),
      getProductById: sl(),
    ),
  );

  /// Features - Shop - Use Cases
  sl.registerLazySingleton(() => GetAllProducts(repository: sl()));
  sl.registerLazySingleton(() => GetProductById(repository: sl()));
  sl.registerLazySingleton(() => GetAllCollections(repository: sl()));
  sl.registerLazySingleton(
      () => GetAllProductsByCollectionId(repository: sl()));
  sl.registerLazySingleton(() => GetSavedSelectedOptions(repository: sl()));
  sl.registerLazySingleton(() => UpdateSelectedOptionsFields(repository: sl()));
  sl.registerLazySingleton(
      () => UpdateSelectedOptionsQuantity(repository: sl()));

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImplementation(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  /// Features - Options Selection - Use Cases
  sl.registerLazySingleton(() => VerifyOptions());

  /// Features - Bag - Use Cases
  sl.registerLazySingleton(() => AddBagItem(repository: sl()));
  sl.registerLazySingleton(() => RemoveBagItem(repository: sl()));
  sl.registerLazySingleton(() => GetAllBagItems(repository: sl()));
  sl.registerLazySingleton(() => UpdateBagItem(repository: sl()));

  sl.registerLazySingleton<BagRepository>(
    () => BagRepositoryImpl(
      bagItemsDataSource: sl(),
      optionsSelectionDataSource: sl(),
      productRemoteDataSource: sl(),
    ),
  );

  /// Features - Favorites - Use Cases
  sl.registerLazySingleton(() => AddFavorite(repository: sl()));
  sl.registerLazySingleton(() => RemoveFavorite(repository: sl()));
  sl.registerLazySingleton(() => GetFavorites(repository: sl()));

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(interface: sl()),
  );

  /// Features - Shop - Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(shopifyStore: sl()),
  );

  /// Features - Bag - Data Sources
  sl.registerLazySingleton<BagItemsLocalDataSource>(
    () => BagItemsLocalDataSourceImpl(interface: sl()),
  );
  sl.registerLazySingleton<OptionsSelectionDataSource>(
    () => OptionsSelectionDataSourceImpl(interface: sl()),
  );

  /// Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /// External
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => ShopifyStore.instance);
  sl.registerLazySingleton(() => Hive);
}
