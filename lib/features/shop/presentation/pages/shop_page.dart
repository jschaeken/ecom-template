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

              const Flexible(
                child: SingleChildScrollView(
                  child: CategoryShop(id: 'Vitamin & Body'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
