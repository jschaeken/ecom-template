import 'package:ecom_template/features/order/domain/entities/successful_fulfilment_tracking_info.dart';
import 'package:equatable/equatable.dart';

class ShopSuccessfulFulfilment extends Equatable {
  final String trackingCompany;
  final List<ShopSuccessfulFulfilmentTrackingInfo> trackingInfo;

  const ShopSuccessfulFulfilment({
    required this.trackingCompany,
    required this.trackingInfo,
  });

  @override
  List<Object?> get props => [trackingCompany, trackingInfo];
}
