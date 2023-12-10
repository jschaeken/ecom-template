import 'package:ecom_template/core/presentation/widgets/product_tile.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatefulFavoriteButton extends StatelessWidget {
  final String productId;

  const StatefulFavoriteButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, favState) {
        switch (favState.runtimeType) {
          case FavoritesInitial:
            return const LoadingStateWidget(
              height: 50,
              width: 50,
            );
          case FavoritesLoading:
            return const LoadingStateWidget(
              height: 50,
              width: 50,
            );
          case FavoritesLoaded ||
                FavoritesAddedLoaded ||
                FavoritesRemovedLoaded ||
                FavoritesEmpty:
            final isFavorite = favState.favorites
                .map((e) => e.parentProdId)
                .toList()
                .contains(productId);
            return FavoriteButton(
              isFavorite: isFavorite,
              onFavoriteTap: () {
                if (isFavorite) {
                  BlocProvider.of<FavoritesBloc>(context).add(
                    RemoveFavoriteEvent(
                      favorite: Favorite(
                        parentProdId: productId,
                      ),
                    ),
                  );
                } else {
                  BlocProvider.of<FavoritesBloc>(context).add(
                    AddFavoriteEvent(
                      favorite: Favorite(
                        parentProdId: productId,
                      ),
                    ),
                  );
                }
              },
            );
          case FavoritesError:
          default:
            return const SizedBox();
        }
      },
    );
  }
}
