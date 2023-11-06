// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bag_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BagItemAdapter extends TypeAdapter<BagItem> {
  @override
  final int typeId = 1;

  @override
  BagItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BagItem(
      title: fields[1] as String,
      id: fields[7] as String,
      availableForSale: fields[4] as bool,
      price: fields[0] as Price,
      sku: fields[5] as String,
      weight: fields[2] as String,
      weightUnit: fields[3] as String,
      image: fields[13] as ShopProductImage?,
      selectedOptions:
          (fields[11] as List?)?.cast<ShopProductSelectedOptions>(),
      requiresShipping: fields[6] as bool,
      quantityAvailable: fields[8] as int,
      compareAtPrice: fields[12] as Price?,
      unitPrice: fields[9] as Price?,
      unitPriceMeasurement: fields[10] as ShopProductUnitPriceMeasurement?,
      quantity: fields[14] as int,
      parentProductId: fields[15] as String,
      uniqueKey: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BagItem obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.price)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.weight)
      ..writeByte(3)
      ..write(obj.weightUnit)
      ..writeByte(4)
      ..write(obj.availableForSale)
      ..writeByte(5)
      ..write(obj.sku)
      ..writeByte(6)
      ..write(obj.requiresShipping)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.quantityAvailable)
      ..writeByte(9)
      ..write(obj.unitPrice)
      ..writeByte(10)
      ..write(obj.unitPriceMeasurement)
      ..writeByte(11)
      ..write(obj.selectedOptions)
      ..writeByte(12)
      ..write(obj.compareAtPrice)
      ..writeByte(13)
      ..write(obj.image)
      ..writeByte(14)
      ..write(obj.quantity)
      ..writeByte(15)
      ..write(obj.parentProductId)
      ..writeByte(16)
      ..write(obj.uniqueKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BagItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
