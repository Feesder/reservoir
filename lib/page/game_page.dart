import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reservoir/page/result_page.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GamePage extends StatefulWidget {
  final int volume;

  const GamePage({
    Key? key,
    required this.volume,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GamePageState(volume: volume);
  }
}

class _GamePageState extends State<GamePage> {
  final int volume;
  late int _volumeChangeAble;
  List<int> points = [0, 0];
  List<bool> activates = [];
  int roundCounter = 1;
  int number = 0;
  String advice = "Сделайте первый ход";
  int sumPointsFirstPlayer = 0;
  int sumPointsSecondPlayer = 0;

  final apiKey = "AIzaSyBT5zRAya9owQehjMO8Vfc2H6xfa_wW3iY";

  _GamePageState({
    required this.volume
  });

  @override
  void initState() {
    super.initState();
    _volumeChangeAble = volume;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              background: Container(
                color: Colors.green,
                child: const Icon(Icons.check),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                child: const Icon(Icons.cancel_outlined),
              ),
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                  activates.add(false);
                }

                if (direction == DismissDirection.endToStart) {
                  activates.add(true);
                }

                if (number % 2 != 0) {
                  debugPrint("${number}");
                  if (activates[number] == true && activates[number - 1] == true) {
                    points.add(0);
                    points.add(0);
                  } else if (activates[number] == false && activates[number - 1] == true) {
                    setState(() {
                      points.add(30);
                      points.add(0);
                      sumPointsFirstPlayer += 30;
                      _volumeChangeAble -= 30;
                    });
                  } else if (activates[number] == true && activates[number - 1] == false) {
                    setState(() {
                      points.add(0);
                      points.add(30);
                      sumPointsSecondPlayer += 30;
                      _volumeChangeAble -= 30;
                    });
                  } else {
                    setState(() {
                      points.add(10);
                      points.add(10);
                      sumPointsFirstPlayer += 10;
                      sumPointsSecondPlayer += 10;
                      _volumeChangeAble -= 20;
                    });
                  }

                  roundCounter++;
                }

                if (_volumeChangeAble <= 30) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultPage(
                        rounds: roundCounter,
                        points: points,
                        volume: volume,
                        activates: activates,
                        sumPointsFirstPlayer: sumPointsFirstPlayer,
                        sumPointsSecondPlayer: sumPointsSecondPlayer,
                      ))
                  );
                }

                setState(() {
                  number++;
                });

                for (int i = 0; i < activates.length; i++) {
                  debugPrint("${i}: ${activates[i]}");
                }

                for (int i = 0; i < points.length; i++) {
                  debugPrint("points ${i}: ${points[i]}");
                }

                generateAdvice();
              },
              child: Container(
                color: Colors.grey[850],
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "Вы страна ${(number % 2) + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w500
                            )
                          ),
                        ),
                        Center(
                          child: Text(
                              "Обьем воды: $_volumeChangeAble",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        ),
                        Center(
                          child: Text(
                              "1 страна: $sumPointsFirstPlayer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        ),
                        Center(
                          child: Text(
                              "2 страна: $sumPointsSecondPlayer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 150,
                        child: Text(
                            "Совет: $advice",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            )
                        ),
                      ),
                    )
                  ],
                )
              )
            );
        }),
      ),
    );
  }

  void generateAdvice() async {
    setState(() {
      advice = "Генерация";
    });

    String prompt;
    if (number % 2 == 0) {
      prompt = """
      Ты играешь игру "Дилемма заключенного". ваш противник получил 
      $sumPointsSecondPlayer очков, а вы $sumPointsFirstPlayer очков. 
      """;

      for (int i = 0; i < activates.length; i += 2) {
        prompt += "Ты сделал вот такие ходы: ${activates[i] ? "Обманул" : "Сотрудничал"}.\n";
      }

      for (int i = 1; i < activates.length; i += 2) {
        prompt += "Противник сделал такие ходы: ${activates[i] ? "Обманул" : "Сотрудничал"}.\n";
      }
    } else {
      prompt  = """
      Ты играешь игру "Дилемма заключенного". ваш противник получил 
      $sumPointsFirstPlayer очков, а вы $sumPointsSecondPlayer очков. 
      """;

      for (int i = 1; i < activates.length; i += 2) {
        prompt += "Ты сделал вот такие ходы: ${activates[i] ? "Обманул" : "Сотрудничал"}.\n";
      }

      for (int i = 0; i < activates.length; i += 2) {
        prompt += "Противник сделал такие ходы: ${activates[i] ? "Обманул" : "Сотрудничал"}.\n";
      }
    }

    prompt +=
    """
    Дай совет, какую стратегию лучше всего выбрать. Объясни выбор. 
    Твой совет не должен первышать 25 слов.
    """;

    debugPrint(prompt);

    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    debugPrint(response.text);
    setState(() {
      advice = response.text!;
    });
  }
}