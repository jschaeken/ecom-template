import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';
import 'package:equatable/equatable.dart';

part 'options_selection_event.dart';
part 'options_selection_state.dart';

class OptionsSelectionBloc
    extends Bloc<OptionsSelectionEvent, OptionsSelectionState> {
  GetSavedSelectedOptions getSavedSelectedOptions;
  SaveSelectedOptions saveSelectedOptions;

  OptionsSelectionBloc(
      {required this.getSavedSelectedOptions,
      required this.saveSelectedOptions})
      : super(OptionsSelectionInitial()) {
    on<OptionsSelectionEvent>((event, emit) async {
      switch (event.runtimeType) {
        case OptionsSelectionChanged:
          emit(const OptionsSelectionLoadingState());
          (event as OptionsSelectionChanged);
          final changedKey = event.optionName;
          final changedIndexValue = event.indexValue;
          final changedProductId = event.productId;
          final currentSelectedOptions =
              await getSavedSelectedOptions(Params(id: changedProductId));
          await currentSelectedOptions.fold(
            (failure) {
              emit(OptionsSelectionInitial());
            },
            (optionsSelection) async {
              var modifiableMap = optionsSelection;
              modifiableMap ??= const OptionsSelections(
                selectedOptions: {},
              );
              modifiableMap.selectedOptions
                  .addAll({changedKey: changedIndexValue});
              await saveSelectedOptions(
                SelectedOptionsParams(
                  productId: changedProductId,
                  optionsSelection: modifiableMap,
                ),
              );
              emit(
                  OptionsSelectionLoadedState(optionsSelection: modifiableMap));
            },
          );
          break;
      }
    });
  }
}
