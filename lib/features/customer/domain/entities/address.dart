import 'package:equatable/equatable.dart';

class ShopAddress extends Equatable {
  final String? id;
  final String? address1;
  final String? address2;
  final String? city;
  final String? company;
  final String? country;
  final String? countryCode;
  final String? firstName;
  final String? lastName;
  final String? formattedArea;
  final String? latitude;
  final String? longitude;
  final String? name;
  final String? phone;
  final String? province;
  final String? provinceCode;
  final String? zip;

  const ShopAddress({
    this.id,
    this.address1,
    this.address2,
    this.city,
    this.company,
    this.country,
    this.countryCode,
    this.firstName,
    this.lastName,
    this.formattedArea,
    this.latitude,
    this.longitude,
    this.name,
    this.phone,
    this.province,
    this.provinceCode,
    this.zip,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        address1,
        address2,
        city,
        company,
        country,
        countryCode,
        firstName,
        lastName,
        formattedArea,
        latitude,
        longitude,
        name,
        phone,
        province,
        provinceCode,
        zip,
      ];
}
