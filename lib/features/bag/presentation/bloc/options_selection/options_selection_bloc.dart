import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_saved_selected_options.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'options_selection_event.dart';
part 'options_selection_state.dart';

class OptionsSelectionBloc
    extends Bloc<OptionsSelectionEvent, OptionsSelectionState> {
  GetSavedSelectedOptions getSavedSelectedOptions;
  UpdateSelectedOptions updateSelectedOptions;

  OptionsSelectionBloc(
      {required this.getSavedSelectedOptions,
      required this.updateSelectedOptions})
      : super(OptionsSelectionInitial()) {
    on<OptionsSelectionEvent>((event, emit) async {
      switch (event.runtimeType) {
        case OptionsSelectionChanged:
          emit(const OptionsSelectionLoadingState());
          (event as OptionsSelectionChanged);
          final productId = event.productId;
          final changedKey = event.optionName;
          final changedIndexValue = event.indexValue;
          await updateSelectedOptions(
            SelectedOptionsParams(
              productId: productId,
              optionsSelection: OptionsSelections(
                selectedOptions: {
                  changedKey: changedIndexValue,
                },
              ),
            ),
          );
          final res = await getSavedSelectedOptions(
            Params(id: productId),
          );
          res.fold((l) {
            emit(OptionsSelectionErrorState(failure: l));
          }, (optionsSelections) {
            emit(OptionsSelectionLoadedState(
              optionsSelection: optionsSelections ??
                  const OptionsSelections(
                    selectedOptions: {},
                  ),
            ));
          });
          break;
        case GetSavedSelectedOptionsEvent:
          emit(const OptionsSelectionLoadingState());
          final productId = (event as GetSavedSelectedOptionsEvent).productId;
          final res = await getSavedSelectedOptions(
            Params(id: productId),
          );
          res.fold((l) {
            emit(OptionsSelectionErrorState(failure: l));
          }, (optionsSelections) {
            debugPrint('new optionsSelections: $optionsSelections');
            emit(OptionsSelectionLoadedState(
              optionsSelection: optionsSelections ??
                  const OptionsSelections(
                    selectedOptions: {},
                  ),
            ));
          });
          break;
      }
    });
  }
}
