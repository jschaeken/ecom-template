import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/features/shop/presentation/views/category_shop.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({required this.pageTitle, super.key});

  final String pageTitle;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin {
  late String pageTitle;
  late TextEditingController searchController;
  late TabController tabController;
  final String accountInitials = 'JS';

  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;
    searchController = TextEditingController();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderRow(
                pageTitle: pageTitle,
                accountInitials: accountInitials,
                shadow: false,
                child: CustomSearchBar(controller: searchController),
              ),
              // Categories Tab Bar
              TabBar(
                isScrollable: true,
                controller: tabController,
                labelColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: 'Food & Drink'),
                  Tab(text: 'Vitamin & Body'),
                  Tab(text: 'Household'),
                  Tab(text: 'Pet'),
                ],
              ),
              // Tab Bar View
              Flexible(
                // height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  viewportFraction: 1,
                  // physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: const [
                    CategoryShop(id: 'Food'),
                    CategoryShop(id: 'Vitamin & Body'),
                    CategoryShop(id: 'Household'),
                    CategoryShop(id: 'Pet'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
