part of 'searching_bloc.dart';

sealed class SearchingEvent extends Equatable {
  const SearchingEvent();

  @override
  List<Object> get props => [];
}

// Initial
class SearchingInitialEvent extends SearchingEvent {}

// Searching
class TextInputSearchEvent extends SearchingEvent {
  const TextInputSearchEvent({required this.searchText});

  final String searchText;

  @override
  List<Object> get props => [searchText];
}

// Cancel
class SearchingCancelEvent extends SearchingEvent {}
