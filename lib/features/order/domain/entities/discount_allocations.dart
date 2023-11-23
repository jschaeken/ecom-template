import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/order/discount_allocations/discount_allocations.dart';

class ShopDiscountAllocations extends Equatable {
  final Price? allocatedAmount;

  const ShopDiscountAllocations({this.allocatedAmount});

  @override
  List<Object?> get props => [allocatedAmount];

  static ShopDiscountAllocations fromDiscountAllocations(
      DiscountAllocations discountAllocation) {
    return ShopDiscountAllocations(
      allocatedAmount: discountAllocation.allocatedAmount != null
          ? Price.fromPriceV2(discountAllocation.allocatedAmount!)
          : null,
    );
  }

  DiscountAllocations toDiscountAllocations() {
    return DiscountAllocations(
      allocatedAmount:
          allocatedAmount != null ? Price.toPriceV2(allocatedAmount!) : null,
    );
  }
}
