import 'dart:developer';

import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/saved_product_list_tile.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/presentation/pages/product_page.dart';
import 'package:ecom_template/features/shop/presentation/widgets/empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  final String pageTitle;

  const FavoritesPage({required this.pageTitle, super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FavoritesBloc>(context).add(GetFavoritesEvent());
    return Scaffold(
      body: Column(
        children: [
          HeaderRow(
            pageTitle: pageTitle,
            accountInitials: 'JS',
          ),
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, favoritesState) {
              // Loading State
              if (favoritesState is FavoritesLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }

              // Loaded State
              else if (favoritesState is FavoritesLoaded) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: favoritesState.favorites.favorites.length,
                    itemBuilder: (context, index) {
                      final favoriteProduct =
                          favoritesState.favorites.favorites[index];
                      return Dismissible(
                        key: Key(favoriteProduct.parentProdId.toString()),
                        onDismissed: (direction) {
                          BlocProvider.of<FavoritesBloc>(context).add(
                            ToggleFavoriteEvent(
                              productId: favoriteProduct.parentProdId,
                            ),
                          );
                        },
                        child: SavedProductListTile(
                          title: favoriteProduct.parentProdId,
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => ProductPage(
                                id: favoriteProduct.parentProdId,
                              ),
                            ));
                          },
                          // price: favoriteProduct.productVariants.first.price,
                          // imageUrl: favoriteProduct.images.isNotEmpty
                          //     ? favoriteProduct.images[0].originalSrc
                          //     : null,
                        ),
                      );
                    },
                  ),
                );
              }

              // Error State
              else if (favoritesState is FavoritesError) {
                return Center(
                  child: Text(favoritesState.message),
                );
              }

              // Initial State
              else if (favoritesState is FavoritesInitial) {
                BlocProvider.of<FavoritesBloc>(context)
                    .add(GetFavoritesEvent());
                return const SizedBox();
              }

              // Default
              else if (favoritesState is FavoritesEmpty) {
                return const Expanded(
                  child: EmptyView(
                    icon: CupertinoIcons.heart_slash_fill,
                    title: 'Your favorites is empty',
                    subtitle:
                        'Press the heart icon on a product to save it here',
                  ),
                );
              } else {
                log('FavoritesPage: Unknown State: $favoritesState');
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
