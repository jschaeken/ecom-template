part of 'collections_view_bloc.dart';

sealed class CollectionsViewEvent extends Equatable {
  const CollectionsViewEvent();

  @override
  List<Object> get props => [];
}

final class LoadCollections extends CollectionsViewEvent {}

final class RefreshCollections extends CollectionsViewEvent {}

final class LoadMoreCollections extends CollectionsViewEvent {}
