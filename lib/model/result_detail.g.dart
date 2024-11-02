// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResultDetailAdapter extends TypeAdapter<ResultDetail> {
  @override
  final int typeId = 1;

  @override
  ResultDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResultDetail(
      rounds: fields[0] as int,
      volume: fields[1] as int,
      sumPointsFirstPlayer: fields[2] as int,
      sumPointsSecondPlayer: fields[3] as int,
      time: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ResultDetail obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.rounds)
      ..writeByte(1)
      ..write(obj.volume)
      ..writeByte(2)
      ..write(obj.sumPointsFirstPlayer)
      ..writeByte(3)
      ..write(obj.sumPointsSecondPlayer)
      ..writeByte(4)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
