import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/features/shop/presentation/bloc/searching/searching_bloc.dart';
import 'package:ecom_template/features/shop/presentation/views/category_shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final String accountInitials = 'JS';
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    pageTitle = widget.pageTitle;
    focusNode = FocusNode();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchingBloc, SearchingState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  HeaderRow(
                    pageTitle: pageTitle,
                    accountInitials: accountInitials,
                    shadow: false,
                    child: CustomActiveSearchBar(
                      controller: searchController,
                    ),
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
      },
    );
  }
}
