import 'package:dartz/dartz.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_totals.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';

class CalculateBagTotals extends UseCase<BagTotals, List<BagItem>> {
  @override
  Future<Either<Failure, BagTotals>> call(List<BagItem> params) async {
    double subtotal = 0.0;
    for (BagItem bagItem in params) {
      subtotal += (bagItem.price.amount * bagItem.quantity);
    }
    return Right(BagTotals(
      subtotal: Price(amount: subtotal, currencyCode: 'EUR'),
      shipping: const Price(amount: 0.0, currencyCode: 'EUR'),
      taxes: const Price(amount: 0.0, currencyCode: 'EUR'),
      total: Price(amount: subtotal, currencyCode: 'EUR'),
    ));
  }
}
