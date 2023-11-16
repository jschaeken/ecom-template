import 'package:equatable/equatable.dart';

class ShopDiscountAllocations extends Equatable {
  final String allocatedAmount;

  const ShopDiscountAllocations({required this.allocatedAmount});

  @override
  List<Object?> get props => [allocatedAmount];
}
