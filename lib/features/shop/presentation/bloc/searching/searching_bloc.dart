import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:ecom_template/features/shop/domain/usecases/get_products_by_substring.dart';
import 'package:equatable/equatable.dart';

part 'searching_event.dart';
part 'searching_state.dart';

class SearchingBloc extends Bloc<SearchingEvent, SearchingState> {
  final GetProductsBySubstring getProductsBySubstring;

  SearchingBloc({required this.getProductsBySubstring})
      : super(SearchingInactive()) {
    on<SearchingEvent>((event, emit) async {
      switch (event.runtimeType) {
        // When the user taps on the search bar
        case SearchingInitialEvent:
          emit(const SearchingInitial(searchHistory: []));
          break;
        // When the user types in the search bar
        case TextInputSearchEvent:
          final String searchText = (event as TextInputSearchEvent).searchText;
          emit(SearchLoading(searchText: searchText));
          final response = await getProductsBySubstring(Params(id: searchText));
          response.fold((l) {
            emit(SearchFailure(searchText: searchText));
          }, (products) {
            if (products.isEmpty) {
              emit(SearchSuccessEmpty(searchText: searchText));
            } else {
              emit(SearchSuccess(searchText: searchText, products: products));
            }
          });
          break;
        // When the user taps on the cancel button
        case SearchingCancelEvent:
          emit(SearchingInactive());
          break;
      }
    });
  }
}
