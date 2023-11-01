part of 'images_bloc.dart';

sealed class ImagesEvent extends Equatable {
  final int variantIndexSelected;
  final String? currentImageUrl;

  const ImagesEvent({
    this.variantIndexSelected = 0,
    this.currentImageUrl,
  });

  @override
  List<Object> get props => [variantIndexSelected];
}

class VariantImageSelected extends ImagesEvent {
  final int index;
  const VariantImageSelected({required this.index})
      : super(variantIndexSelected: index);

  @override
  List<Object> get props => [index];
}

class MainImageUnselected extends ImagesEvent {}

class MainImageSelected extends ImagesEvent {
  final String imageUrl;
  const MainImageSelected({required this.imageUrl})
      : super(currentImageUrl: imageUrl);

  @override
  List<Object> get props => [imageUrl];
}
