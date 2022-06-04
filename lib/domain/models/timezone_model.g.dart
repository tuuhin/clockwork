// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeZoneModelAdapter extends TypeAdapter<TimeZoneModel> {
  @override
  final int typeId = 1;

  @override
  TimeZoneModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeZoneModel(
      region: fields[2] as String?,
      area: fields[0] as String,
      location: fields[1] as String,
      endpoint: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TimeZoneModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.area)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.region)
      ..writeByte(3)
      ..write(obj.endpoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeZoneModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
