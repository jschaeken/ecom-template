import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/saved_product_list_tile.dart';
import 'package:ecom_template/features/shop/presentation/bloc/collections_view/collections_view_bloc.dart';
import 'package:ecom_template/features/shop/presentation/bloc/searching/searching_bloc.dart';
import 'package:ecom_template/features/shop/presentation/pages/product_page.dart';
import 'package:ecom_template/features/shop/presentation/widgets/category_loader.dart';
import 'package:ecom_template/features/shop/presentation/widgets/empty_view.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorePage extends StatelessWidget {
  ExplorePage({required this.pageTitle, super.key});

  final String pageTitle;
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final String accountInitials = 'JS';
  final collectionsBloc = sl<CollectionsViewBloc>();

  @override
  Widget build(BuildContext context) {
    collectionsBloc.add(LoadCollections());
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        BlocProvider.of<SearchingBloc>(context)
            .add(TextInputSearchEvent(searchText: searchController.text));
      } else {
        BlocProvider.of<SearchingBloc>(context).add(SearchingInitialEvent());
      }
    });
    return BlocBuilder<SearchingBloc, SearchingState>(
      builder: (context, state) {
        return Scaffold(
          body: BlocProvider(
            create: (context) => collectionsBloc,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                RefreshIndicator.adaptive(
                  onRefresh: () async {
                    collectionsBloc.add(LoadCollections());
                  },
                  color: Theme.of(context).primaryColor,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      children: [
                        // Header Title and Account
                        HeaderRow(
                          pageTitle: pageTitle,
                          accountInitials: accountInitials,
                          child: CustomActiveSearchBar(
                            controller: searchController,
                          ),
                        ),
                        state.runtimeType == SearchingInactive
                            ? CategoryLoader(collectionsBloc: collectionsBloc)
                            : Builder(
                                builder: (context) {
                                  switch (state.runtimeType) {
                                    case SearchingInitial:
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 20,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: Constants.padding
                                                  .copyWith(bottom: 0),
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                child: Padding(
                                                  padding:
                                                      Constants.innerPadding,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          'Search History Item ${index + 1}'),
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.clear,
                                                          color: Theme.of(
                                                                  context)
                                                              .unselectedWidgetColor,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    case SearchLoading:
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: Constants.padding
                                                  .copyWith(bottom: 0),
                                              child: const LoadingStateWidget(
                                                height: 70,
                                              ),
                                            );
                                          });
                                    case SearchSuccess:
                                      state as SearchSuccess;
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: state.products.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: Constants.padding
                                                  .copyWith(bottom: 0),
                                              child: SavedProductListTile(
                                                title:
                                                    state.products[index].title,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                      builder: (context) {
                                                        return ProductPage(
                                                            id: state
                                                                .products[index]
                                                                .id);
                                                      },
                                                    ),
                                                  );
                                                },
                                                imageUrl: state
                                                    .products[index]
                                                    .productVariants
                                                    .first
                                                    .image
                                                    ?.originalSrc,
                                                price: state
                                                    .products[index]
                                                    .productVariants
                                                    .first
                                                    .price,
                                              ),
                                            );
                                          });
                                    case SearchFailure:
                                      return const Column(
                                        children: [Text('Failure State')],
                                      );
                                    case SearchSuccessEmpty:
                                      return const Column(
                                        children: [
                                          SizedBox(
                                            height: 100,
                                          ),
                                          EmptyView(
                                            icon: CupertinoIcons.search,
                                            title: 'No results found',
                                            subtitle:
                                                'Try searching for something else',
                                          ),
                                        ],
                                      );
                                    default:
                                      return const SizedBox();
                                  }
                                },
                              ).animate().fadeIn()
                      ],
                    ),
                  ),
                ),

                // Overlay Search Bar
                ListenableBuilder(
                    listenable: scrollController,
                    builder: (context, child) {
                      bool overlay = scrollController.offset > 70;
                      if (scrollController.position.userScrollDirection ==
                              ScrollDirection.forward &&
                          !overlay &&
                          scrollController.offset > 70) {
                        overlay = true;
                      } else if (overlay &&
                          (scrollController.position.userScrollDirection ==
                                  ScrollDirection.reverse ||
                              scrollController.offset < 70)) {
                        overlay = false;
                      }
                      return Visibility(
                        visible: overlay,
                        child: Container(
                          color: Theme.of(context).canvasColor,
                          child: Padding(
                            padding: Constants.padding,
                            child: CustomActiveSearchBar(
                              controller: searchController,
                            ),
                          ),
                        ).animate().fadeIn(
                              duration: const Duration(milliseconds: 100),
                            ),
                      );
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
