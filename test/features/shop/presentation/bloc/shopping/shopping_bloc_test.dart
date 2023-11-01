import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_products.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_concrete_product_by_id.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllProducts extends Mock implements GetAllProducts {}

class MockGetProductById extends Mock implements GetProductById {}

void main() {
  late ShoppingBloc bloc;
  late MockGetAllProducts mockGetAllProducts;
  late MockGetProductById mockGetProductById;

  setUp(() {
    mockGetAllProducts = MockGetAllProducts();
    mockGetProductById = MockGetProductById();
    bloc = ShoppingBloc(
      getAllProducts: mockGetAllProducts,
      getProductById: mockGetProductById,
    );
  });

  test('Initial state should be ShoppingInitial', () {
    // assert
    expect(bloc.state, equals(ShoppingInitial()));
  });

  group('Get Product By Id', () {
    const String tId = '1';
    const tProduct = ShopProduct(
      id: '1',
      availableForSale: true,
      createdAt: '',
      images: [],
      metafields: [],
      options: [],
      productType: '',
      productVariants: [],
      publishedAt: '',
      tags: [],
      title: '',
      updatedAt: '',
      vendor: '',
    );

    test('should get data from the getProductById usecase ', () async {
      // arrange
      when(() => mockGetProductById(const Params(id: tId)))
          .thenAnswer((_) async => const Right(tProduct));
      // act
      bloc.add(const GetProductByIdEvent(id: tId));
      await untilCalled(() => mockGetProductById(const Params(id: tId)));
      // assert
      verify(() => mockGetProductById(const Params(id: tId)));
    });

    test(
        'Should emit states: [Loading, Error (with server failure message)] when getting data fails from the getProductById due to sever failure',
        () async {
      // arrange
      when(() => mockGetProductById(const Params(id: tId)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        ShoppingLoading(),
        ShoppingError(
            message: SERVER_FAILURE_MESSAGE, failure: ServerFailure()),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetProductByIdEvent(id: tId));
    });

    test(
        'Should emit states: [Loading, Error (with internet connection failure message)] when getting data fails from the getProductById due to internet connection issues',
        () async {
      // arrange
      when(() => mockGetProductById(const Params(id: tId)))
          .thenAnswer((_) async => Left(InternetConnectionFailure()));
      // assert later
      final expected = [
        ShoppingLoading(),
        ShoppingError(
            message: INTERNET_CONNECTION_FAILURE_MESSAGE,
            failure: InternetConnectionFailure()),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetProductByIdEvent(id: tId));
    });

    test(
        'Should emit states: [Loading, Loaded] when the product is succesfully returned from the usecase',
        () {
      // arrange
      when(() => mockGetProductById(const Params(id: tId)))
          .thenAnswer((_) async => const Right(tProduct));
      // assert later
      final expected = [
        ShoppingLoading(),
        const ShoppingLoadedById(product: tProduct),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetProductByIdEvent(id: tId));
    });
  });

  group('Get All Products', () {
    const tProducts = [
      ShopProduct(
        id: '1',
        availableForSale: true,
        createdAt: '',
        images: [],
        metafields: [],
        options: [],
        productType: '',
        productVariants: [],
        publishedAt: '',
        tags: [],
        title: '',
        updatedAt: '',
        vendor: '',
      ),
      ShopProduct(
        id: '2',
        availableForSale: true,
        createdAt: '',
        images: [],
        metafields: [],
        options: [],
        productType: '',
        productVariants: [],
        publishedAt: '',
        tags: [],
        title: '',
        updatedAt: '',
        vendor: '',
      ),
    ];

    test('should get data from the getAllProducts usecase ', () async {
      // arrange
      when(() => mockGetAllProducts(NoParams()))
          .thenAnswer((_) async => const Right(tProducts));
      // act
      bloc.add(const GetAllProductsEvent());
      await untilCalled(() => mockGetAllProducts(NoParams()));
      // assert
      verify(() => mockGetAllProducts(NoParams()));
    });

    test(
        'Should emit states: [Loading, Error (with server failure message)] when getting data fails from the getProductById due to sever failure',
        () async {
      // arrange
      when(() => mockGetAllProducts(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        ShoppingLoading(),
        ShoppingError(
          message: SERVER_FAILURE_MESSAGE,
          failure: ServerFailure(),
        ),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetAllProductsEvent());
    });

    test(
        'Should emit states: [Loading, Error (with internet connection failure message)] when getting data fails from the getProductById due to internet connection issues',
        () async {
      // arrange
      when(() => mockGetAllProducts(NoParams()))
          .thenAnswer((_) async => Left(InternetConnectionFailure()));
      // assert later
      final expected = [
        ShoppingLoading(),
        ShoppingError(
            message: INTERNET_CONNECTION_FAILURE_MESSAGE,
            failure: InternetConnectionFailure()),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetAllProductsEvent());
    });
  });
}
