part of 'images_bloc.dart';

sealed class ImagesState extends Equatable {
  final int variantIndexSelected;
  const ImagesState({this.variantIndexSelected = 0});

  @override
  List<Object> get props => [];
}

final class ImagesInitial extends ImagesState {
  const ImagesInitial({required int variantIndexSelected})
      : super(variantIndexSelected: variantIndexSelected);

  @override
  List<Object> get props => [variantIndexSelected];
}

final class VariantSelectionUpdate extends ImagesState {
  const VariantSelectionUpdate({required int variantIndexSelected})
      : super(variantIndexSelected: variantIndexSelected);

  @override
  List<Object> get props => [variantIndexSelected];
}

final class MainImageEnlarged extends ImagesState {
  final String imageUrl;
  const MainImageEnlarged(
      {required int variantIndexSelected, required this.imageUrl})
      : super(variantIndexSelected: variantIndexSelected);

  @override
  List<Object> get props => [variantIndexSelected, imageUrl];
}
