// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_product_selected_options.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopProductSelectedOptionsAdapter
    extends TypeAdapter<ShopProductSelectedOptions> {
  @override
  final int typeId = 4;

  @override
  ShopProductSelectedOptions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopProductSelectedOptions(
      name: fields[0] as String,
      value: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopProductSelectedOptions obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopProductSelectedOptionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
