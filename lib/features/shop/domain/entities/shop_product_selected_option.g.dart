// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_product_selected_option.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopProductSelectedOptionAdapter
    extends TypeAdapter<ShopProductSelectedOption> {
  @override
  final int typeId = 4;

  @override
  ShopProductSelectedOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopProductSelectedOption(
      name: fields[0] as String,
      value: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopProductSelectedOption obj) {
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
      other is ShopProductSelectedOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
