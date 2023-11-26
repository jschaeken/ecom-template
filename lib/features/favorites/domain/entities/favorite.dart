import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'favorite.g.dart';

@HiveType(typeId: 6)
class Favorite extends Equatable {
  @HiveField(0)
  final String parentProdId;

  const Favorite({required this.parentProdId});

  @override
  List<Object?> get props => [parentProdId];
}
