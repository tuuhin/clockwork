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
      id: fields[0] as int,
      at: fields[1] as DateTime,
      repeat: fields[2] as RepeatEnum,
      vibrate: fields[3] as bool,
      label: fields[4] as String?,
      deleteAfterDone: fields[5] as bool,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmsModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.at)
      ..writeByte(2)
      ..write(obj.repeat)
      ..writeByte(3)
      ..write(obj.vibrate)
      ..writeByte(4)
      ..write(obj.label)
      ..writeByte(5)
      ..write(obj.deleteAfterDone)
      ..writeByte(6)
      ..write(obj.isActive);
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
