import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_collection.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_all_collections.dart';
import 'package:equatable/equatable.dart';

part 'collections_view_event.dart';
part 'collections_view_state.dart';

class CollectionsViewBloc
    extends Bloc<CollectionsViewEvent, CollectionsViewState> {
  final GetAllCollections getAllCollections;

  CollectionsViewBloc({required this.getAllCollections})
      : super(CollectionsViewInitial()) {
    on<CollectionsViewEvent>((event, emit) async {
      switch (event.runtimeType) {
        case LoadCollections:
          emit(CollectionsViewLoading());
          final collectionsOrFailure = await getAllCollections(NoParams());
          collectionsOrFailure.fold(
            (failure) {
              emit(
                CollectionsViewError(
                    message: failure.toString(), failure: failure),
              );
            },
            (collections) {
              emit(
                CollectionsViewLoaded(
                  collections: collections,
                ),
              );
            },
          );
          break;
        case RefreshCollections:
          emit(CollectionsViewLoading());
          final collectionsOrFailure = await getAllCollections(NoParams());
          collectionsOrFailure.fold(
            (failure) {
              emit(
                CollectionsViewError(
                    message: failure.toString(), failure: failure),
              );
            },
            (collections) {
              emit(
                CollectionsViewLoaded(
                  collections: collections,
                ),
              );
            },
          );
          break;
      }
    });
  }
}
