// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarms_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmsModelAdapter extends TypeAdapter<AlarmsModel> {
  @override
  final int typeId = 0;

  @override
  AlarmsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmsModel(
      at: fields[0] as DateTime,
      repeat: fields[1] as bool,
      vibrate: fields[2] as bool,
      label: fields[3] as String?,
      deleteAfterDone: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.at)
      ..writeByte(1)
      ..write(obj.repeat)
      ..writeByte(2)
      ..write(obj.vibrate)
      ..writeByte(3)
      ..write(obj.label)
      ..writeByte(4)
      ..write(obj.deleteAfterDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
