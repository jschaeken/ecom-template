import 'package:equatable/equatable.dart';

class ShopShippingAddress extends Equatable {
  final String id;
  final String address1;
  final String city;
  final String country;
  final String zip;
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
}
