import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/network/network_info.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_auth_datasource.dart';
import 'package:ecom_template/features/customer/data/models/shopify_user_model.dart';
import 'package:ecom_template/features/customer/data/repositories/customer_auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerAuthDataSource extends Mock
    implements CustomerAuthDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockCustomerAuthDataSource mockCustomerAuthDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late CustomerAuthRepositoryImpl customerAuthRepositoryImpl;

  setUp(() {
    mockCustomerAuthDataSource = MockCustomerAuthDataSource();
    mockNetworkInfo = MockNetworkInfo();
    customerAuthRepositoryImpl = CustomerAuthRepositoryImpl(
      customerAuthDatasource: mockCustomerAuthDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('signInWithEmailAndPassword', () {
    test(
      'should check if the device is online',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockCustomerAuthDataSource.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const ShopShopifyUserModel());

        // act
        await customerAuthRepositoryImpl.signInWithEmailAndPassword(
            email: '', password: '');
        // assert
        verify(() => mockNetworkInfo.isConnected);
      },
    );

    void runTestsOnline(Function body) {
      group('device is online', () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        body();
      });
    }

    void runTestsOffline(Function body) {
      group('device is offline', () {
        setUp(() {
          when(() => mockNetworkInfo.isConnected)
              .thenAnswer((_) async => false);
        });

        body();
      });
    }

    runTestsOnline(() {
      test(
        'should return a Right(ShopShopifyUser) when the call to the remote data source is successful',
        () async {
          // arrange
          when(() => mockCustomerAuthDataSource.signInWithEmailAndPassword(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => const ShopShopifyUserModel());

          // act
          final result = await customerAuthRepositoryImpl
              .signInWithEmailAndPassword(email: '', password: '');

          // assert
          expect(result, const Right(ShopShopifyUserModel()));
        },
      );

      test(
        'should return a Left(AuthFailure) with the corresponding message when the call to the remote data source throws a AuthException',
        () async {
          // arrange
          const String testMessage = 'test error message';
          when(() => mockCustomerAuthDataSource.signInWithEmailAndPassword(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenThrow(const AuthException(message: testMessage));

          // act
          final result = await customerAuthRepositoryImpl
              .signInWithEmailAndPassword(email: '', password: '');

          // assert
          expect(result, const Left(AuthFailure(message: testMessage)));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return a Left(NetworkFailure) when the device is offline',
        () async {
          // act
          final result = await customerAuthRepositoryImpl
              .signInWithEmailAndPassword(email: '', password: '');

          // assert
          expect(
              result,
              const Left(
                InternetConnectionFailure(
                    message: INTERNET_CONNECTION_FAILURE_MESSAGE),
              ));
        },
      );
    });
  });
}
