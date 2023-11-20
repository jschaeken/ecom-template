part of 'searching_bloc.dart';

sealed class SearchingState extends Equatable {
  const SearchingState();

  @override
  List<Object> get props => [];
}

final class SearchingInactive extends SearchingState {}

final class SearchingInitial extends SearchingState {
  final List<String> searchHistory;

  const SearchingInitial({required this.searchHistory});
}

final class SearchLoading extends SearchingState {
  final String searchText;

  const SearchLoading({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

final class SearchSuccess extends SearchingState {
  final String searchText;
  final List<ShopProduct> products;

  const SearchSuccess({required this.searchText, required this.products});

  @override
  List<Object> get props => [searchText, products];
}

final class SearchSuccessEmpty extends SearchingState {
  final String searchText;

  const SearchSuccessEmpty({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

final class SearchFailure extends SearchingState {
  final String searchText;

  const SearchFailure({required this.searchText});

  @override
  List<Object> get props => [searchText];
}
