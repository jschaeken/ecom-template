import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/features/customer/data/models/shopify_user_model.dart';
import 'package:ecom_template/features/customer/domain/entities/address.dart';
import 'package:ecom_template/features/customer/domain/entities/last_incomplete_checkout.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:ecom_template/features/customer/domain/usecases/email_and_password_sign_in.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmailAndPasswordSignIn extends Mock
    implements EmailAndPasswordSignIn {}

void main() {
  late MockEmailAndPasswordSignIn mockEmailAndPasswordSignIn;
  late CustomerAuthBloc customerAuthBloc;

  setUp(() {
    mockEmailAndPasswordSignIn = MockEmailAndPasswordSignIn();
    customerAuthBloc = CustomerAuthBloc(
      emailAndPasswordSignIn: mockEmailAndPasswordSignIn,
    );

    registerFallbackValue(
      const EmailAndPasswordSignInParams(email: '', password: ''),
    );
  });

  const tEmail = '';
  const tPassword = '';

  ShopShopifyUser shopShopifyUser = const ShopShopifyUser(
      addresses: [
        ShopAddress(
          address1: 'address1',
          address2: 'address2',
          city: 'city',
          country: 'country',
          firstName: 'firstName',
          id: 'id',
          lastName: 'lastName',
          latitude: '0',
          longitude: '0',
          name: 'name',
          phone: 'phone',
          province: 'province',
          provinceCode: 'provinceCode',
          zip: 'zip',
          company: 'company',
          formattedArea: 'formattedArea',
        ),
      ],
      createdAt: 'createdAt',
      displayName: 'displayName',
      email: 'email',
      firstName: 'firstName',
      id: 'id',
      lastName: 'lastName',
      phone: 'phone',
      tags: ['tags'],
      lastIncompleteCheckout: ShopLastIncompleteCheckout(
        completedAt: 'completedAt',
        createdAt: 'createdAt',
        currencyCode: 'currencyCode',
        email: 'email',
        id: 'id',
        lineItems: [],
        lineItemsSubtotalPrice: null,
        totalPriceV2: null,
        webUrl: 'webUrl',
      ));

  group('sign in with email and password event', () {
    test(
        'should emit [CustomerAuthLoading, CustomerAuthLoaded] when email and password sign in is successful',
        () async {
      // arrange
      when(() => mockEmailAndPasswordSignIn(any()))
          .thenAnswer((_) async => Right(shopShopifyUser));

      // assert later
      final expected = [
        CustomerAuthLoading(),
        CustomerAuthSuccess(user: shopShopifyUser),
      ];
      expectLater(customerAuthBloc.stream, emitsInOrder(expected));

      // act
      customerAuthBloc.add(
        const CustomerAuthEmailAndPasswordSignInEvent(
          email: tEmail,
          password: tPassword,
        ),
      );
    });

    test(
      'should emit [CustomerAuthLoading, CustomerAuthError(with failure as argument)] when email and password sign in is unsuccessful',
      () async {
        // arrange
        when(() => mockEmailAndPasswordSignIn(any()))
            .thenAnswer((_) async => const Left(AuthFailure()));

        // assert later
        final expected = [
          CustomerAuthLoading(),
          const CustomerAuthError(failure: AuthFailure()),
        ];
        expectLater(customerAuthBloc.stream, emitsInOrder(expected));

        // act
        customerAuthBloc.add(
          const CustomerAuthEmailAndPasswordSignInEvent(
            email: tEmail,
            password: tPassword,
          ),
        );
      },
    );
  });
}
