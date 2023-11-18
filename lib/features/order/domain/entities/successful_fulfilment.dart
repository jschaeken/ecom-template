import 'package:ecom_template/features/order/domain/entities/successful_fulfilment_tracking_info.dart';
import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/order/successful_fulfillment/successful_fullfilment.dart';

class ShopSuccessfulFulfilment extends Equatable {
  final String? trackingCompany;
  final List<ShopSuccessfulFulfilmentTrackingInfo>? trackingInfo;

  const ShopSuccessfulFulfilment({
    required this.trackingCompany,
    required this.trackingInfo,
  });

  @override
  List<Object?> get props => [trackingCompany, trackingInfo];

  static fromFulfilment(SuccessfulFullfilment fulfilment) {
    return ShopSuccessfulFulfilment(
      trackingCompany: fulfilment.trackingCompany,
      trackingInfo: fulfilment.trackingInfo != null
          ? fulfilment.trackingInfo!
              .map((trackingInfo) => ShopSuccessfulFulfilmentTrackingInfo
                  .fromSuccessfulFulfilmentTrackingInfo(trackingInfo))
              .toList() as List<ShopSuccessfulFulfilmentTrackingInfo>
          : null,
    );
  }
}
