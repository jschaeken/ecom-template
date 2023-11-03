import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/category_box.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/features/shop/presentation/bloc/collections_view/collections_view_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:ecom_template/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({required this.pageTitle, super.key});

  final String pageTitle;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late String pageTitle;
  late ScrollController scrollController;
  late TextEditingController searchController;
  bool overlaySearchBar = false;
  final String accountInitials = 'JS';
  // List<Category> demoCategories = [
  //   Category(
  //     id: '1',
  //     imageUrl: 'https://picsum.photos/701',
  //     title: 'CATEGORY 1',
  //     subtitle: 'Subtitle 1',
  //   ),
  //   Category(
  //     id: '2',
  //     imageUrl: 'https://picsum.photos/702',
  //     title: 'CATEGORY 2',
  //     subtitle: 'Subtitle 2',
  //   ),
  //   Category(
  //     id: '3',
  //     imageUrl: 'https://picsum.photos/703',
  //     title: 'CATEGORY 3',
  //     subtitle: 'Subtitle 3',
  //   ),
  //   Category(
  //     id: '4',
  //     imageUrl: 'https://picsum.photos/704',
  //     title: 'CATEGORY 4',
  //     subtitle: 'Subtitle 4',
  //   ),
  // ];

  final collectionsBloc = sl<CollectionsViewBloc>();

  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;
    scrollController = ScrollController();
    searchController = TextEditingController();
    //When the user scrolls up, the bar will be visible
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !overlaySearchBar &&
          scrollController.offset > 70) {
        setState(() {
          overlaySearchBar = true;
        });
      } else if (overlaySearchBar &&
          (scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse ||
              scrollController.offset < 70)) {
        setState(() {
          overlaySearchBar = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => collectionsBloc,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          RefreshIndicator.adaptive(
            onRefresh: () async {
              collectionsBloc.add(LoadCollections());
              await Future.delayed(const Duration(milliseconds: 400));
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
                    child: CustomSearchBar(controller: searchController),
                  ),

                  // Search Bar

                  // Categories
                  CategoryLoader(collectionsBloc: collectionsBloc),
                ],
              ),
            ),
          ),

          // Overlay Search Bar
          Visibility(
            visible: overlaySearchBar,
            child: Container(
              color: Theme.of(context).canvasColor,
              child: Padding(
                padding: Constants.padding,
                child: CustomSearchBar(controller: searchController),
              ),
            ).animate().fadeIn(
                  duration: const Duration(milliseconds: 100),
                ),
          ),
        ],
      ),
    );
  }
}

class CategoryLoader extends StatelessWidget {
  const CategoryLoader({
    super.key,
    required this.collectionsBloc,
  });

  final CollectionsViewBloc collectionsBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsViewBloc, CollectionsViewState>(
      bloc: collectionsBloc,
      builder: (context, collectionsState) {
        return BlocBuilder<CollectionsViewBloc, CollectionsViewState>(
            builder: (context, state) {
          if (state is CollectionsViewLoaded) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: state.collections.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: Constants.padding,
                  child: CategoryImageBox(
                    imageUrl: state.collections[index].image?.originalSrc,
                    title: state.collections[index].title,
                    subtitle: state.collections[index].description,
                    onTap: () {},
                  ),
                );
              },
            );
          } else if (state is CollectionsViewLoading) {
            return const LoadingStateWidget();
          } else if (state is CollectionsViewError) {
            return IconTextError(failure: state.failure);
          } else if (state is CollectionsViewInitial) {
            return Container(
              color: Colors.red,
              height: 2000,
              width: 10,
            );
          } else if (state is CollectionsViewEmpty) {
            return const Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  'No Collections',
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        });
      },
    );
  }
}
