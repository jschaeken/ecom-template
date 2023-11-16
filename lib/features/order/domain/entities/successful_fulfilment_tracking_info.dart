import 'package:equatable/equatable.dart';

class ShopSuccessfulFulfilmentTrackingInfo extends Equatable {
  final String number;
  final String url;

  const ShopSuccessfulFulfilmentTrackingInfo({
    required this.number,
    required this.url,
  });

  @override
  List<Object?> get props => [number, url];
}
