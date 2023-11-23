import 'package:dartz/dartz.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:ecom_template/features/checkout/domain/usecases/add_discount_code.dart';
import 'package:ecom_template/features/order/domain/entities/discount_allocations.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late MockCheckoutRepository mockCheckoutRepository;
  late AddDiscountCode usecase;
  setUp(() {
    mockCheckoutRepository = MockCheckoutRepository();
    usecase = AddDiscountCode(repository: mockCheckoutRepository);
  });

  const testShopCheckoutWithDiscount = ShopCheckout(
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
        discountAllocations: [
          ShopDiscountAllocations(
            allocatedAmount: Price(amount: 3.80, currencyCode: 'EUR'),
          ),
        ],
        customAttributes: [],
      )
    ],
  );

  const testId = 'id';
  const testDiscountCode = 'discountCode';

  group('Add Discount Code', () {
    test(
        'should return a ShopCheckout object with a discount code applied to the line item',
        () async {
      // arrange
      when(() => mockCheckoutRepository.addDiscountCode(
                checkoutId: any(named: 'checkoutId'),
                discountCode: any(named: 'discountCode'),
              ))
          .thenAnswer(
              (invocation) async => const Right(testShopCheckoutWithDiscount));

      // act
      final result = await usecase(
        const ShopCheckoutActionParams(
          checkoutId: testId,
          option: testDiscountCode,
        ),
      );

      // assert
      expect(result, equals(const Right(testShopCheckoutWithDiscount)));
      verify(
        () => mockCheckoutRepository.addDiscountCode(
          checkoutId: testId,
          discountCode: testDiscountCode,
        ),
      );
    });
  });
}
