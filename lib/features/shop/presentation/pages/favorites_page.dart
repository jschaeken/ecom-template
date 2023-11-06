import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, required this.pageTitle});

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderRow(
            pageTitle: pageTitle,
            accountInitials: 'JS',
          ),
          // const Expanded(
          //   child: EmptyView(
          //     icon: CupertinoIcons.heart_fill,
          //     title: 'Your favorites is empty',
          //     subtitle: 'Add some items to see them here',
          //   ),
          // ),
        ],
      ),
    );
  }
}
