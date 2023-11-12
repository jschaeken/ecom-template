import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/category_box.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/shop/presentation/bloc/collections_view/collections_view_bloc.dart';
import 'package:ecom_template/features/shop/presentation/pages/collection_view.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => CollectionView(
                                  id: state.collections[index].id,
                                  collectionName:
                                      state.collections[index].title,
                                )),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is CollectionsViewLoading) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: Constants.padding,
                  child: CategoryImageBox(
                    title: '',
                    onTap: () {},
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: const Duration(seconds: 2)),
                );
              },
            );
          } else if (state is CollectionsViewError) {
            return IconTextError(failure: state.failure);
          } else if (state is CollectionsViewInitial) {
            return const SizedBox(
              height: 2000,
            );
          } else if (state is CollectionsViewEmpty) {
            return const Column(
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
    );
  }
}
