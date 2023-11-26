import 'dart:developer';

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/saved_product_list_tile.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/features/shop/presentation/pages/product_page.dart';
import 'package:ecom_template/features/shop/presentation/widgets/empty_view.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  final String pageTitle;

  FavoritesPage({required this.pageTitle, super.key});
  final shoppingBloc = sl<ShoppingBloc>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FavoritesBloc>(context).add(GetAllFavoritesEvent());
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
                shoppingBloc.add(GetProductsByListIdsEvent(
                    ids: favoritesState.favorites
                        .map((e) => e.parentProdId)
                        .toList()));
                return BlocBuilder<ShoppingBloc, ShoppingState>(
                  bloc: shoppingBloc,
                  builder: (context, shoppingState) {
                    if (shoppingState is ShoppingError) {
                      return IconTextError(
                        failure: shoppingState.failure,
                      );
                    } else if (shoppingState is ShoppingLoading ||
                        shoppingState is ShoppingInitial) {
                      return const EmptyView(
                        icon: CupertinoIcons.heart_slash_fill,
                        title: 'Your favorites is empty',
                        subtitle:
                            'Press the heart icon on a product to save it here',
                      );
                    }

                    shoppingState as ShoppingLoaded;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: favoritesState.favorites.length,
                        itemBuilder: (context, index) {
                          final favoriteProduct =
                              favoritesState.favorites[index];
                          return index < shoppingState.products.length
                              ? Dismissible(
                                  background: Padding(
                                    padding: Constants.padding
                                        .copyWith(top: 0, left: 0),
                                    child: Container(
                                      color: Colors.red,
                                      child: Padding(
                                        padding: Constants.padding,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              CupertinoIcons.trash,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  key: Key(
                                      favoriteProduct.parentProdId.toString()),
                                  onDismissed: (direction) {
                                    BlocProvider.of<FavoritesBloc>(context).add(
                                      RemoveFavoriteEvent(
                                        favorite: favoriteProduct,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: Constants.padding,
                                    child: SavedProductListTile(
                                      title:
                                          shoppingState.products[index].title,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) => ProductPage(
                                              id: shoppingState
                                                  .products[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      price: shoppingState.products[index]
                                          .productVariants.firstOrNull?.price,
                                      imageUrl: shoppingState.products[index]
                                          .images.firstOrNull?.originalSrc,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: Constants.padding,
                                  child: const LoadingStateWidget(
                                    height: 140,
                                    width: double.infinity,
                                  ),
                                );
                        },
                      ),
                    );
                  },
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
                    .add(GetAllFavoritesEvent());
                return const SizedBox();
              }

              // Empty
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
