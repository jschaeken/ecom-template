import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(const ImagesInitial(variantIndexSelected: 0)) {
    on<ImagesEvent>((event, emit) async {
      switch (event.runtimeType) {
        case VariantImageSelected:
          emit(VariantSelectionUpdate(
              variantIndexSelected: event.variantIndexSelected));
          break;
        case MainImageUnselected:
          emit(VariantSelectionUpdate(
              variantIndexSelected: event.variantIndexSelected));
          break;
        case MainImageSelected:
          emit(MainImageEnlarged(
              variantIndexSelected: event.variantIndexSelected,
              imageUrl: (event as MainImageSelected).imageUrl));
          break;
        default:
          log('Unknown event type in ImagesBloc');
      }
    });
  }
}
