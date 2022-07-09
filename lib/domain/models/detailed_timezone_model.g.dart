// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_timezone_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetailedTimeZoneModelAdapter extends TypeAdapter<DetailedTimeZoneModel> {
  @override
  final int typeId = 2;

  @override
  DetailedTimeZoneModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetailedTimeZoneModel(
      location: fields[0] as String,
      area: fields[1] as String,
      offset: fields[2] as int,
      isSelected: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DetailedTimeZoneModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.area)
      ..writeByte(2)
      ..write(obj.offset)
      ..writeByte(3)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailedTimeZoneModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
