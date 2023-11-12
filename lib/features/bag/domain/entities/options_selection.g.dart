// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options_selection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OptionsSelectionsAdapter extends TypeAdapter<OptionsSelections> {
  @override
  final int typeId = 7;

  @override
  OptionsSelections read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OptionsSelections(
      selectedOptions: (fields[0] as Map).cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, OptionsSelections obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.selectedOptions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionsSelectionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
