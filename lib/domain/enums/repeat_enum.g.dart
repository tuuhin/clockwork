// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repeat_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepeatEnumAdapter extends TypeAdapter<RepeatEnum> {
  @override
  final int typeId = 3;

  @override
  RepeatEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RepeatEnum.daily;
      case 1:
        return RepeatEnum.once;
      default:
        return RepeatEnum.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RepeatEnum obj) {
    switch (obj) {
      case RepeatEnum.daily:
        writer.writeByte(0);
        break;
      case RepeatEnum.once:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
