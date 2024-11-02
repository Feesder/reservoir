import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

part 'result_detail.g.dart';

ResultDetail resultDetailFromJson(String str) => ResultDetail.fromJson(jsonDecode(str));
String resultDetailToJson(ResultDetail result) => jsonEncode(result.toJson());

@HiveType(typeId: 1)
class ResultDetail {

  ResultDetail({
    required this.rounds,
    required this.volume,
    required this.sumPointsFirstPlayer,
    required this.sumPointsSecondPlayer,
    required this.time
  });

  @HiveField(0)
  final int rounds;

  @HiveField(1)
  final int volume;

  @HiveField(2)
  final int sumPointsFirstPlayer;

  @HiveField(3)
  final int sumPointsSecondPlayer;

  @HiveField(4)
  final DateTime time;

  factory ResultDetail.fromJson(Map<String, dynamic> json) => ResultDetail(
    rounds: json["rounds"],
    volume: json["volume"],
    sumPointsFirstPlayer: json["sumPointsFirstPlayer"],
    sumPointsSecondPlayer: json["sumPointsSecondPlayer"],
    time: json["time"]
  );

  Map<String, dynamic> toJson() => {
    "rounds": rounds,
    "volume": volume,
    "sumPointsFirstPlayer": sumPointsFirstPlayer,
    "sumPointsSecondPlayer": sumPointsSecondPlayer,
    "time": time
  };
}