import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/empty_view.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BagPage extends StatelessWidget {
  const BagPage({super.key, required this.pageTitle});

  final String pageTitle;
  // final bagBloc = sl<BagBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderRow(
            pageTitle: pageTitle,
            accountInitials: 'JS',
          ),
          BlocBuilder<BagBloc, BagState>(
            builder: (context, state) {
              if (state is BagInitial || state is BagEmptyState) {
                return const Expanded(
                  child: Center(
                    child: EmptyView(
                      icon: CupertinoIcons.bag_fill,
                      title: 'Your bag is empty',
                      subtitle: 'Add items to your bag to continue',
                    ),
                  ),
                );
              } else if (state is BagLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is BagLoadedState) {
                return ListView.builder(
                  itemCount: state.bagItems.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(state.bagItems[index].id),
                      onDismissed: (direction) =>
                          BlocProvider.of<BagBloc>(context).add(
                        RemoveBagItemEvent(
                          bagItem: state.bagItems[index],
                        ),
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(state.bagItems[index].title),
                          subtitle: Text(
                              state.bagItems[index].price.amount.toString()),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is BagErrorState) {
                return IconTextError(
                  failure: state.failure,
                );
              } else {
                return IconTextError(failure: UnknownFailure());
              }
            },
          ),
        ],
      ),
    );
  }
}
