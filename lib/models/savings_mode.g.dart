// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavingsModeAdapter extends TypeAdapter<SavingsMode> {
  @override
  final int typeId = 3;

  @override
  SavingsMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SavingsMode.manual;
      case 1:
        return SavingsMode.automaticRoundup;
      case 2:
        return SavingsMode.reverseChallenge;
      default:
        return SavingsMode.manual;
    }
  }

  @override
  void write(BinaryWriter writer, SavingsMode obj) {
    switch (obj) {
      case SavingsMode.manual:
        writer.writeByte(0);
        break;
      case SavingsMode.automaticRoundup:
        writer.writeByte(1);
        break;
      case SavingsMode.reverseChallenge:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavingsModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
