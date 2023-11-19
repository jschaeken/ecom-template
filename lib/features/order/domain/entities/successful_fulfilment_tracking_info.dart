import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/order/successful_fulfillment/successful_fulfilment_tracking_info/successful_fulfilment_tracking_info.dart';

class ShopSuccessfulFulfilmentTrackingInfo extends Equatable {
  final String? number;
  final String? url;

  const ShopSuccessfulFulfilmentTrackingInfo({
    required this.number,
    required this.url,
  });

  @override
  List<Object?> get props => [number, url];

  static ShopSuccessfulFulfilmentTrackingInfo
      fromSuccessfulFulfilmentTrackingInfo(
          SuccessfulFullfilmentTrackingInfo trackingInfo) {
    return ShopSuccessfulFulfilmentTrackingInfo(
      number: trackingInfo.number,
      url: trackingInfo.url,
    );
  }
}
