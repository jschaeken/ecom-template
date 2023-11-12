import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:equatable/equatable.dart';

class FavoriteParams extends Equatable {
  final Favorite favorite;

  const FavoriteParams({required this.favorite});

  @override
  List<Object?> get props => [favorite];
}
