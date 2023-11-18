import 'package:equatable/equatable.dart';
import 'package:shopify_flutter/models/src/checkout/mailing_address/mailing_address.dart';
import 'package:shopify_flutter/models/src/order/shipping_address/shipping_address.dart';
import 'package:shopify_flutter/models/src/shopify_user/address/address.dart';

class ShopShippingAddress extends Equatable {
  final String? id;
  final String? address1;
  final String? city;
  final String? country;
  final String? zip;
  final String? lastName;
  final String? name;
  final String? firstName;
  final String? address2;
  final String? company;
  final String? countryCodeV2;
  final String? formattedArea;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? province;
  final String? provinceCode;

  const ShopShippingAddress({
    required this.id,
    required this.address1,
    required this.city,
    required this.country,
    required this.zip,
    this.lastName,
    this.name,
    this.firstName,
    this.address2,
    this.company,
    this.countryCodeV2,
    this.formattedArea,
    this.latitude,
    this.longitude,
    this.phone,
    this.province,
    this.provinceCode,
  });

  @override
  List<Object?> get props => [
        id,
        address1,
        city,
        country,
        zip,
        lastName,
        name,
        firstName,
        address2,
        company,
        countryCodeV2,
        formattedArea,
        latitude,
        longitude,
        phone,
        province,
        provinceCode,
      ];

  static fromAddress(Address shippingAddress) {
    return ShopShippingAddress(
      id: shippingAddress.id,
      address1: shippingAddress.address1,
      city: shippingAddress.city,
      country: shippingAddress.country,
      zip: shippingAddress.zip,
      lastName: shippingAddress.lastName,
      name: shippingAddress.name,
      firstName: shippingAddress.firstName,
      address2: shippingAddress.address2,
      company: shippingAddress.company,
      countryCodeV2: shippingAddress.countryCode,
      formattedArea: shippingAddress.formattedArea,
      latitude: double.tryParse(shippingAddress.latitude ?? '-'),
      longitude: double.tryParse(shippingAddress.longitude ?? '-'),
      phone: shippingAddress.phone,
      province: shippingAddress.province,
      provinceCode: shippingAddress.provinceCode,
    );
  }

  static fromShippingAddress(ShippingAddress shippingAddress) {
    return ShopShippingAddress(
      id: shippingAddress.id,
      address1: shippingAddress.address1,
      city: shippingAddress.city,
      country: shippingAddress.country,
      zip: shippingAddress.zip,
      lastName: shippingAddress.lastName,
      name: shippingAddress.name,
      firstName: shippingAddress.firstName,
      address2: shippingAddress.address2,
      company: shippingAddress.company,
      countryCodeV2: shippingAddress.countryCodeV2,
      latitude: shippingAddress.latitude,
      longitude: shippingAddress.longitude,
      phone: shippingAddress.phone,
      province: shippingAddress.province,
      provinceCode: shippingAddress.provinceCode,
    );
  }

  static fromMailingAddress(MailingAddress mailingAddress) {
    return ShopShippingAddress(
      id: mailingAddress.id,
      address1: mailingAddress.address1,
      city: mailingAddress.city,
      country: mailingAddress.country,
      zip: mailingAddress.zip,
      lastName: mailingAddress.lastName,
      name: mailingAddress.name,
      firstName: mailingAddress.firstName,
      address2: mailingAddress.address2,
      company: mailingAddress.company,
      countryCodeV2: mailingAddress.countryCodeV2,
      latitude: mailingAddress.latitude,
      longitude: mailingAddress.longitude,
      phone: mailingAddress.phone,
      province: mailingAddress.province,
      provinceCode: mailingAddress.provinceCode,
    );
  }

  static toAddress(ShopShippingAddress? shippingAddress) {
    return Address(
      id: shippingAddress?.id,
      address1: shippingAddress?.address1,
      city: shippingAddress?.city,
      country: shippingAddress?.country,
      zip: shippingAddress?.zip,
      lastName: shippingAddress?.lastName,
      name: shippingAddress?.name,
      firstName: shippingAddress?.firstName,
      address2: shippingAddress?.address2,
      company: shippingAddress?.company,
      countryCode: shippingAddress?.countryCodeV2,
      formattedArea: shippingAddress?.formattedArea,
      latitude: shippingAddress?.latitude.toString(),
      longitude: shippingAddress?.longitude.toString(),
      phone: shippingAddress?.phone,
      province: shippingAddress?.province,
      provinceCode: shippingAddress?.provinceCode,
    );
  }
}
