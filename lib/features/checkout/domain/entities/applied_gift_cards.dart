import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';

class ShopAppliedGiftCards extends Equatable {
  final Price amountUsedV2;
  final Price balanceV2;
  final String id;

  const ShopAppliedGiftCards({
    required this.amountUsedV2,
    required this.balanceV2,
    required this.id,
  });

  @override
  List<Object?> get props => [amountUsedV2, balanceV2, id];
}
