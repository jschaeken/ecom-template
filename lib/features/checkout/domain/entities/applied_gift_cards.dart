import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/checkout/applied_gift_cards/applied_gift_cards.dart';

class ShopAppliedGiftCards extends Equatable {
  final Price amountUsed;
  final Price balance;
  final String id;

  const ShopAppliedGiftCards({
    required this.amountUsed,
    required this.balance,
    required this.id,
  });

  @override
  List<Object?> get props => [amountUsed, balance, id];

  static fromAppliedGiftCards(AppliedGiftCards appliedGiftCard) {
    return ShopAppliedGiftCards(
      amountUsed: Price.fromPriceV2(appliedGiftCard.amountUsedV2),
      balance: Price.fromPriceV2(appliedGiftCard.balanceV2),
      id: appliedGiftCard.id,
    );
  }
}
