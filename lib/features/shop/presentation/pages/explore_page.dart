import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/features/shop/presentation/bloc/collections_view/collections_view_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/category_loader.dart';
import 'package:ecom_template/injection_container.dart';
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
                      child: CustomSearchBar(controller: searchController),
                    ),

                    // Categories
                    CategoryLoader(collectionsBloc: collectionsBloc),
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
                        child: CustomSearchBar(controller: searchController),
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
  }
}
