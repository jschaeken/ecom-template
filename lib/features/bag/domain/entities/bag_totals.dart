import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:equatable/equatable.dart';

class BagTotals extends Equatable {
  final Price subtotal;
  final Price shipping;
  final Price taxes;
  final Price total;

  const BagTotals({
    this.subtotal = const Price(amount: 0.0, currencyCode: 'EUR'),
    this.shipping = const Price(amount: 0.0, currencyCode: 'EUR'),
    this.taxes = const Price(amount: 0.0, currencyCode: 'EUR'),
    this.total = const Price(amount: 0.0, currencyCode: 'EUR'),
  });

  @override
  List<Object> get props => [subtotal, total, shipping, taxes];
}
