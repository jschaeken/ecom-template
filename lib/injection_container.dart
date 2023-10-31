import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/shop/data/datasources/product_remote_datasource.dart';
import 'package:ecom_template/features/shop/data/repositories/product_repositoty_impl.dart';
import 'package:ecom_template/features/shop/domain/repositories/product_repository.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shopify_flutter/shopify/src/shopify_store.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  /// Features - Shop
  sl.registerFactory(
    () => ShoppingBloc(
      getAllProducts: sl(),
      getProductById: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetProductById(sl()));

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImplementation(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(shopifyStore: sl()),
  );

  /// Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /// External
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => ShopifyStore.instance);
}
