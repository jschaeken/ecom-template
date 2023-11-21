import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/checkout/domain/entities/checkout.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';
import 'package:ecom_template/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:ecom_template/features/checkout/domain/usecases/get_checkout_info.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutRepository extends Mock implements CheckoutRepository {}

void main() {
  late GetCheckoutInfo usecase;
  late MockCheckoutRepository mockCheckoutRepository;

  setUp(() {
    mockCheckoutRepository = MockCheckoutRepository();
    usecase = GetCheckoutInfo(repository: mockCheckoutRepository);
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
        customAttributes: [],
      )
    ],
  );

  const tId = 'id';

  test('should get checkout info from the repository', () async {
    // arrange
    when(() => mockCheckoutRepository.getCheckoutById(
            checkoutId: any(named: 'checkoutId')))
        .thenAnswer((_) async => const Right(testShopCheckout));
    // act
    final result = await usecase(const Params(id: tId));
    // assert
    expect(result, const Right(testShopCheckout));
    verify(() => mockCheckoutRepository.getCheckoutById(checkoutId: tId));
    verifyNoMoreInteractions(mockCheckoutRepository);
  });
}
