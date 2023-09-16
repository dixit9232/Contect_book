// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contect_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContectDataAdapter extends TypeAdapter<Contect_Data> {
  @override
  final int typeId = 0;

  @override
  Contect_Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contect_Data(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Contect_Data obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.contect)
      ..writeByte(2)
      ..write(obj.gender)
      ..writeByte(3)
      ..write(obj.cropImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContectDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
