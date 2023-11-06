// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_product_unit_price_measurement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopProductUnitPriceMeasurementAdapter
    extends TypeAdapter<ShopProductUnitPriceMeasurement> {
  @override
  final int typeId = 5;

  @override
  ShopProductUnitPriceMeasurement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopProductUnitPriceMeasurement(
      measuredType: fields[0] as String,
      quantityUnit: fields[1] as String,
      quantityValue: fields[2] as double,
      referenceUnit: fields[3] as String,
      referenceValue: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ShopProductUnitPriceMeasurement obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.measuredType)
      ..writeByte(1)
      ..write(obj.quantityUnit)
      ..writeByte(2)
      ..write(obj.quantityValue)
      ..writeByte(3)
      ..write(obj.referenceUnit)
      ..writeByte(4)
      ..write(obj.referenceValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopProductUnitPriceMeasurementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
