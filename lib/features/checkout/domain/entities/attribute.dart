import 'package:equatable/equatable.dart';

class ShopAttribute extends Equatable {
  final String key;
  final String? value;

  const ShopAttribute({
    required this.key,
    this.value,
  });

  @override
  List<Object?> get props => [
        key,
        value,
      ];
}
