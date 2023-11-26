// ignore_for_file: must_be_immutable

import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/domain/entities/price.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/features/shop/presentation/pages/product_page.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionView extends StatefulWidget {
  final String id;
  final String collectionName;

  const CollectionView(
      {required this.id, required this.collectionName, super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  final shoppingBloc = sl<ShoppingBloc>();

  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    shoppingBloc.add(GetProductsByCollectionIdEvent(id: widget.id));
    return BlocProvider(
      create: (context) => shoppingBloc,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: BlocBuilder<ShoppingBloc, ShoppingState>(
            builder: (context, state) {
              return TextHeadline(
                text: widget.collectionName,
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.search),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: Constants.padding.copyWith(right: 6),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: Constants.borderRadius,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: isGrid
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Padding(
                                padding: Constants.innerPadding,
                                child: FractionallySizedBox(
                                  widthFactor: 0.5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: Constants.borderRadius,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isGrid = !isGrid;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: CustomIcon(
                                        CupertinoIcons.rectangle_grid_2x2_fill,
                                      ),
                                    ),
                                    RotatedBox(
                                      quarterTurns: 1,
                                      child: CustomIcon(
                                        CupertinoIcons.rectangle_fill,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: Constants.padding.copyWith(left: 6),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: Constants.borderRadius,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomIcon(CupertinoIcons.sort_down, size: 25),
                              TextSubHeadline(
                                text: 'Filter and Sort',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const StandardSpacing(),
              BlocBuilder<ShoppingBloc, ShoppingState>(
                builder: (context, state) {
                  if (state is ShoppingLoaded) {
                    if (isGrid) {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, favoriteState) {
                              bool? isFavorite;
                              if (favoriteState is FavoritesAddedLoaded ||
                                  favoriteState is FavoritesRemovedLoaded ||
                                  favoriteState is FavoritesLoaded ||
                                  favoriteState is FavoritesEmpty) {
                                isFavorite = favoriteState.favorites
                                    .map((e) => e.parentProdId)
                                    .contains(state.products[index].id);
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return ProductPage(
                                          id: state.products[index].id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: ProductContainer(
                                  product: state.products[index],
                                  isFavorite: isFavorite,
                                  onFavoriteTap: () {
                                    if (isFavorite == null) {
                                      return;
                                    } else if (isFavorite) {
                                      BlocProvider.of<FavoritesBloc>(context)
                                          .add(
                                        RemoveFavoriteEvent(
                                          favorite: Favorite(
                                            parentProdId:
                                                state.products[index].id,
                                          ),
                                        ),
                                      );
                                    } else {
                                      BlocProvider.of<FavoritesBloc>(context)
                                          .add(
                                        AddFavoriteEvent(
                                          favorite: Favorite(
                                            parentProdId:
                                                state.products[index].id,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  price: state.products[index].productVariants
                                      .first.price,
                                ),
                              );
                            },
                          );
                        },
                      ).animate().fadeIn();
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, favoriteState) {
                              bool? isFavorite;
                              if (favoriteState is FavoritesAddedLoaded ||
                                  favoriteState is FavoritesRemovedLoaded ||
                                  favoriteState is FavoritesLoaded ||
                                  favoriteState is FavoritesEmpty) {
                                isFavorite = favoriteState.favorites
                                    .map((e) => e.parentProdId)
                                    .contains(state.products[index].id);
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return ProductPage(
                                          id: state.products[index].id,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 500,
                                  width: double.infinity,
                                  child: ProductContainer(
                                    product: state.products[index],
                                    isFavorite: isFavorite,
                                    onFavoriteTap: () {
                                      if (isFavorite == null) {
                                        return;
                                      } else if (isFavorite) {
                                        BlocProvider.of<FavoritesBloc>(context)
                                            .add(
                                          RemoveFavoriteEvent(
                                            favorite: Favorite(
                                              parentProdId:
                                                  state.products[index].id,
                                            ),
                                          ),
                                        );
                                      } else {
                                        BlocProvider.of<FavoritesBloc>(context)
                                            .add(
                                          AddFavoriteEvent(
                                            favorite: Favorite(
                                              parentProdId:
                                                  state.products[index].id,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    price: state.products[index].productVariants
                                        .first.price,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ).animate().fadeIn();
                    }
                  } else if (state is ShoppingLoading) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Theme.of(context).cardColor,
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: const Duration(seconds: 2),
                            );
                      },
                    );
                  } else if (state is ShoppingError) {
                    return IconTextError(failure: state.failure);
                  } else if (state is ShoppingInitial) {
                    return const SizedBox();
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductContainer extends StatelessWidget {
  const ProductContainer({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.price,
    required this.onFavoriteTap,
  });

  final ShopProduct product;
  final bool? isFavorite;
  final Price price;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        product.images.first.originalSrc,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: Constants.padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBody(
                      text: product.title,
                    ),
                    const StandardSpacing(),
                    TextBody(
                      text:
                          product.productVariants.first.price.formattedPrice(),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: Constants.padding.copyWith(top: 10, right: 10),
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, shape: BoxShape.circle),
                child: Padding(
                  padding: Constants.padding,
                  child: isFavorite == null
                      ? const SizedBox()
                      : (isFavorite ?? false)
                          ? const CustomIcon(
                              CupertinoIcons.heart_fill,
                              color: Colors.red,
                            )
                          : CustomIcon(
                              CupertinoIcons.heart,
                              color: Theme.of(context).primaryColor,
                            ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
