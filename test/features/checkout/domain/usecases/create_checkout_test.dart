import 'package:dartz/dartz.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/shipping_address.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:ecom_template/features/checkout/domain/usecases/create_checkout.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository mockCheckoutRepository;
  late CreateCheckout usecase;
  setUp(() {
    mockCheckoutRepository = MockCheckoutRepository();
    usecase = CreateCheckout(repository: mockCheckoutRepository);
  });

  const testShopCheckout = ShopCheckout(
    id: 'id',
    subtotalPrice: Price(amount: 12.34, currencyCode: 'USD'),
    totalPrice: Price(amount: 12.34, currencyCode: 'USD'),
    totalTax: Price(amount: 0, currencyCode: 'USD'),
    appliedGiftCards: [],
    order: null,
    orderStatusUrl: null,
    completedAt: null,
    note: null,
    email: null,
    shippingAddress: null,
    shippingLine: null,
    shopifyPaymentsAccountId: null,
    updatedAt: null,
    webUrl: null,
    ready: true,
    availableShippingRates: null,
    createdAt: 'createdAt',
    currencyCode: 'currencyCode',
    taxesIncluded: true,
    taxExempt: true,
    requiresShipping: true,
    lineItems: [
      ShopLineItem(
          title: 'title',
          quantity: 2,
          discountAllocations: [],
          customAttributes: [])
    ],
  );

  group('Create Checkout', () {
    test('should return a ShopCheckout object', () async {
      // arrange
      when(() => mockCheckoutRepository.createCheckout(
            lineItems: any(named: 'lineItems'),
            email: any(named: 'email'),
            shippingAddress: any(named: 'shippingAddress'),
          )).thenAnswer((invocation) async => const Right(testShopCheckout));

      // act
      final result = await usecase(
        const ShopCreateCheckoutParams(
          lineItems: [
            ShopLineItem(
              title: 'title',
              quantity: 1,
              customAttributes: [],
              discountAllocations: [],
            )
          ],
          shippingAddress: ShopShippingAddress(
              firstName: 'firstName',
              lastName: 'lastName',
              name: 'firstName lastName',
              id: 'id',
              address1: 'address1',
              city: 'city',
              country: 'country',
              zip: 'zip'),
          email: 'email',
        ),
      );

      // assert
      expect(result, equals(const Right(testShopCheckout)));
      verify(() => mockCheckoutRepository.createCheckout(
            lineItems: any(named: 'lineItems'),
            email: any(named: 'email'),
            shippingAddress: any(named: 'shippingAddress'),
          ));
    });
  });
}
