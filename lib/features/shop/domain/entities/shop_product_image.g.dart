// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_product_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopProductImageAdapter extends TypeAdapter<ShopProductImage> {
  @override
  final int typeId = 3;

  @override
  ShopProductImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopProductImage(
      altText: fields[0] as String?,
      id: fields[1] as String?,
      originalSrc: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopProductImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.altText)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.originalSrc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopProductImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
