import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/presentation/widgets/featured_brand_tile.dart';
import 'package:ecom_template/core/presentation/widgets/multi_image_banner.dart';
import 'package:ecom_template/core/presentation/widgets/product_tile.dart';
import 'package:ecom_template/core/presentation/widgets/slim_text_tile.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/shop/presentation/bloc/shopping/shopping_bloc.dart';
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
  final bloc = sl<ShoppingBloc>();

  List<String> promoImages = [
    'https://www.hereshealth.ie/cdn/shop/files/viridian2_614x350.jpg?v=1696405958',
    'https://www.hereshealth.ie/cdn/shop/files/ecoverzero2_592x364.jpg?v=1696405604',
    'https://www.hereshealth.ie/cdn/shop/files/hhbannerupdated_b9d83d32-e311-47fd-a402-7a2cd6f0a9c4_1227x725.jpg?v=1696499376%201.25x',
  ];

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
    bloc.add(const GetAllProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocProvider(
        create: (_) => bloc,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Promo PageView Header
            MultiImageBanner(images: promoImages),

            const SizedBox(
              height: 20,
            ),

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
                            return LargeProductTile(
                              product: state.products[index],
                              onTap: () {
                                Navigator.push(context, CupertinoPageRoute(
                                  builder: (context) {
                                    return ProductPage(
                                        id: state.products[index].id);
                                  },
                                ));
                              },
                              onFavoriteTap: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is ShoppingLoading) {
                  return const LoadingStateWidget(
                    height: 240,
                  );
                } else if (state is ShoppingError) {
                  switch (state.failure.runtimeType) {
                    case ServerFailure:
                      return const IconTextError(
                        icon: CupertinoIcons.exclamationmark_triangle,
                        text: 'A Sever Error Has Occured',
                      );
                    case InternetConnectionFailure:
                      return const IconTextError(
                        icon: CupertinoIcons.wifi_slash,
                        text: 'No Internet Conection',
                      );
                    default:
                      return const IconTextError(
                        icon: CupertinoIcons.question,
                        text: 'An Unknown Error Has Occured',
                      );
                  }
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
              child: const TextHeadline(text: 'Trending Categories'),
            ),

            // ListView of Product Categories
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return SlimTextTile(
                  key: UniqueKey(),
                  text: 'Category ${index + 1}',
                  onTap: () {},
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
