import 'package:bloc/bloc.dart';
import 'package:ecom_template/core/usecases/usecase.dart';
import 'package:ecom_template/features/bag/domain/entities/bag_item_data.dart';
import 'package:ecom_template/features/bag/domain/entities/options_selection.dart';
import 'package:ecom_template/features/bag/domain/entities/product_selections.dart';
import 'package:ecom_template/features/bag/domain/usecases/get_saved_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/option_selection_verification.dart';
import 'package:ecom_template/features/bag/domain/usecases/save_selected_options.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_quantity.dart';
import 'package:ecom_template/features/bag/domain/usecases/update_selected_options_fields.dart';
import 'package:ecom_template/features/bag/util/failures.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'options_selection_event.dart';
part 'options_selection_state.dart';

class OptionsSelectionBloc
    extends Bloc<OptionsSelectionEvent, OptionsSelectionState> {
  GetSavedSelectedOptions getSavedSelectedOptions;
  UpdateSelectedOptionsQuantity updateSelectedOptionsQuantity;
  UpdateSelectedOptionsFields updateSelectedOptionsFields;
  VerifyOptions verifyOptions;

  OptionsSelectionBloc({
    required this.getSavedSelectedOptions,
    required this.updateSelectedOptionsQuantity,
    required this.updateSelectedOptionsFields,
    required this.verifyOptions,
  }) : super(OptionsSelectionInitial()) {
    on<OptionsSelectionEvent>((event, emit) async {
      switch (event.runtimeType) {
        case OptionsSelectionChanged:
          debugPrint('OptionsSelectionChanged');
          // emit(const OptionsSelectionLoadingState());
          (event as OptionsSelectionChanged);
          // Destructuring
          final ShopProduct product = event.product;
          final String changedKey = event.optionName;
          final int changedIndexValue = event.indexValue;
          // Saving the changed option
          await updateSelectedOptionsFields(
            SelectedOptionsParams(
              productId: product.id,
              optionsSelection: OptionsSelections(
                selectedOptions: {
                  changedKey: changedIndexValue,
                },
              ),
            ),
          );

          // Getting the current saved options, and creating a BagItemData object, which is emitted
          await _handleOptionsSelectionsChanged(
            product: product,
            emit: emit,
          );
          break;

        case CheckValidOptionsSelectionEvent:
          event as CheckValidOptionsSelectionEvent;
          final ShopProduct product = event.product;
          await _handleOptionsSelectionsChanged(
            product: product,
            emit: emit,
          );
          break;
        case OptionsSelectionQuantityChanged:
          event as OptionsSelectionQuantityChanged;
          // Destructuring
          final ShopProduct product = event.product;
          final int quantity = event.quantity;
          if (quantity < 1 || quantity > 10) {
            return;
          }
          // Saving the changed option
          await updateSelectedOptionsQuantity(
            SelectedOptionsParams(
              productId: product.id,
              optionsSelection: OptionsSelections(
                quantity: quantity,
              ),
            ),
          );
          // Getting the current saved options
          await _handleOptionsSelectionsChanged(
            product: product,
            emit: emit,
          );
          break;
        case OptionsSelectionStarted:
      }
    });
  }

  Future<void> _handleOptionsSelectionsChanged({
    required ShopProduct product,
    required Emitter<OptionsSelectionState> emit,
  }) async {
    final currentSavedOptions = await getSavedSelectedOptions(
      Params(id: product.id),
    );

    List<ProductSelection> currentSelections = [];
    ProductSelections? currentProductSelections;
    await currentSavedOptions.fold((failure) async {
      debugPrint('OptionsSelectionChanged failure: $failure, $product');
      // If theres a failure, then the chosen value are set to the first value in the list of that option
      for (ShopProductOption option in product.options) {
        currentSelections.add(
          ProductSelection(
            title: option.name,
            values: option.values,
            chosenValue: option.values[0],
          ),
        );
      }
      currentProductSelections = ProductSelections(
        selections: currentSelections,
        quantity: 1,
      );
    }, (optionsSelections) async {
      for (ShopProductOption option in product.options) {
        currentSelections.add(
          ProductSelection(
            title: option.name,
            values: option.values,
            chosenValue: option
                .values[optionsSelections.selectedOptions[option.name] ?? 0],
          ),
        );
      }
      currentProductSelections = ProductSelections(
        selections: currentSelections,
        quantity: optionsSelections.quantity,
      );
    });
    final bagItemOrFailure = verifyOptions.getBagItemData(
      shopProduct: product,
      productSelections: currentProductSelections!,
    );

    // If the options are complete, then the bag item data is returned, else the failure is returned
    await bagItemOrFailure.fold(
      (l) async {
        emit(
          OptionsSelectionErrorState(
            currentSelections: currentProductSelections!,
            failure: const IncompleteOptionsSelectionFailure(
              message:
                  'There was an error with finding the selected product variant.',
            ),
          ),
        );
      },
      (bagItemData) async {
        emit(
          OptionsSelectionLoadedCompleteState(
            bagItemData: bagItemData,
            currentSelections: currentProductSelections!,
          ),
        );
      },
    );
  }
}
