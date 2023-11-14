// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bag_item_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BagItemDataAdapter extends TypeAdapter<BagItemData> {
  @override
  final int typeId = 0;

  @override
  BagItemData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BagItemData(
      parentProductId: fields[0] as String,
      quantity: fields[1] as int,
      productVariantId: fields[2] as String,
      productVariantTitle: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BagItemData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.parentProductId)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.productVariantId)
      ..writeByte(3)
      ..write(obj.productVariantTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BagItemDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
