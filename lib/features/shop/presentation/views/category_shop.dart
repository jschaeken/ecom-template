import 'package:ecom_template/core/presentation/widgets/featured_brand_tile.dart';
import 'package:ecom_template/core/presentation/widgets/product_tile.dart';
import 'package:ecom_template/core/presentation/widgets/slim_text_tile.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/favorites/domain/entities/favorite.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/collections_view/collections_view_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
import 'package:ecom_template/features/shop/presentation/pages/collection_view.dart';
import 'package:ecom_template/features/shop/presentation/pages/product_page.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants.dart';

class CategoryShop extends StatefulWidget {
  const CategoryShop({super.key, required this.id});

  final String id;

  @override
  State<CategoryShop> createState() => _CategoryShopState();
}

class _CategoryShopState extends State<CategoryShop> {
  final shopBloc = sl<ShoppingBloc>();
  final collectionsBloc = sl<CollectionsViewBloc>();

  List<List<String>> featuredBrandImages = [
    [
      'Veridian',
      'https://viridian-nutrition.com/cdn/shop/files/New_Website_Mobile_Banners-02.jpg?v=1689847168',
    ],
    [
      'A. Vogel',
      'https://www.avogel.com/img/client/startseite/slider/AVogel-Home-Slider-International.jpg?m=1532000218',
    ],
    [
      'Four Sigmatic',
      'https://images.ctfassets.net/x1qkutirh4di/5r5JvAoiBWPa09ACRpZ1gD/f626b668dde021f2f8eb4d7fa960c896/FS_Photoshoot_March2023_Day4-1509__1_.jpeg?w=768&fm=webp&q=75',
    ],
    [
      'Fabu U',
      'https://evergreen.ie/cdn/shop/collections/fabu.jpg?v=1696507601',
    ],
  ];

  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.37,
  );

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    shopBloc.add(const GetAllProductsEvent());
    collectionsBloc.add(LoadCollections());
    BlocProvider.of<FavoritesBloc>(context).add(GetFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => collectionsBloc,
      child: BlocProvider(
        create: (_) => shopBloc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Promo PageView Header
            /* MultiImageBanner(images: promoImages), */

            BlocBuilder<ShoppingBloc, ShoppingState>(
              builder: (context, state) {
                if (state is ShoppingLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Featured Products
                      Padding(
                        padding: Constants.padding.copyWith(bottom: 0),
                        child: TextHeadline(
                            text: 'Featured ${widget.id} Products'),
                      ),

                      SizedBox(
                        height: 240,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          controller: pageController,
                          itemCount: state.products.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return BlocBuilder<FavoritesBloc, FavoritesState>(
                              builder: (context, favoriteState) {
                                bool? isFavorite;
                                if (favoriteState is FavoritesAddedLoaded ||
                                    favoriteState is FavoritesRemovedLoaded ||
                                    favoriteState is FavoritesLoaded ||
                                    favoriteState is FavoritesEmpty) {
                                  isFavorite = favoriteState.favorites.favorites
                                      .map((e) => e.parentProdId)
                                      .contains(state.products[index].id);
                                }
                                return LargeProductTile(
                                  product: state.products[index],
                                  isLast: index == state.products.length - 1,
                                  onTap: () {
                                    Navigator.push(context, CupertinoPageRoute(
                                      builder: (context) {
                                        return ProductPage(
                                          id: state.products[index].id,
                                        );
                                      },
                                    ));
                                  },
                                  isFavorite: isFavorite,
                                  onFavoriteTap: () {
                                    if (isFavorite == null) {
                                      BlocProvider.of<FavoritesBloc>(context)
                                          .add(GetFavoritesEvent());
                                    } else {
                                      BlocProvider.of<FavoritesBloc>(context)
                                          .add(ToggleFavoriteEvent(
                                        productId: state.products[index].id,
                                      ));
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is ShoppingLoading) {
                  return Padding(
                    padding: Constants.padding,
                    child: const LoadingStateWidget(
                      height: 240,
                    ),
                  );
                } else if (state is ShoppingError) {
                  return IconTextError(
                    failure: state.failure,
                  );
                } else if (state is ShoppingInitial) {
                  return const SizedBox(
                    height: 240,
                  );
                } else {
                  return const SizedBox(
                    height: 240,
                  );
                }
              },
            ),

            // Featured Brands Grid View Title
            Padding(
              padding: Constants.padding,
              child: TextHeadline(text: 'Featured ${widget.id} Brands'),
            ),

            // Featured Brands Grid View
            BlocBuilder<ShoppingBloc, ShoppingState>(builder: (context, state) {
              if (state is ShoppingLoaded) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: Constants.padding.copyWith(top: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.7,
                    crossAxisSpacing: Constants.padding.right.abs(),
                    mainAxisSpacing: Constants.padding.bottom.abs(),
                  ),
                  itemCount: featuredBrandImages.length,
                  itemBuilder: (context, index) {
                    return FeaturedBrandTile(brand: featuredBrandImages[index]);
                  },
                );
              } else if (state is ShoppingLoading) {
                return const SizedBox();
              } else if (state is ShoppingError) {
                return const SizedBox();
              } else if (state is ShoppingInitial) {
                return const SizedBox();
              } else {
                return const SizedBox();
              }
            }),

            //List of Product Categories Title
            Padding(
              padding: Constants.padding,
              child: const TextHeadline(text: 'Trending Collections'),
            ),

            // ListView of Product Categories
            BlocBuilder<CollectionsViewBloc, CollectionsViewState>(
              builder: (context, state) {
                return BlocBuilder<CollectionsViewBloc, CollectionsViewState>(
                    builder: (context, state) {
                  if (state is CollectionsViewLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.collections.length,
                      itemBuilder: (context, index) {
                        return SlimTextTile(
                          key: UniqueKey(),
                          text: state.collections[index].title,
                          onTap: () {
                            Navigator.push(context, CupertinoPageRoute(
                              builder: (context) {
                                return CollectionView(
                                  id: state.collections[index].id,
                                  collectionName:
                                      state.collections[index].title,
                                );
                              },
                            ));
                          },
                        );
                      },
                    );
                  } else if (state is CollectionsViewLoading) {
                    return const LoadingStateWidget();
                  } else if (state is CollectionsViewError) {
                    return IconTextError(failure: state.failure);
                  } else if (state is CollectionsViewInitial) {
                    return const LoadingStateWidget();
                  } else if (state is CollectionsViewEmpty) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        TextBody(
                          text: 'No Collections',
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
