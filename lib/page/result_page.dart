import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:reservoir/database/mongodb.dart';
import 'package:reservoir/model/result_detail.dart';
import 'package:reservoir/page/intro_page.dart';

class ResultPage extends StatefulWidget {
  final int rounds;
  final List<int> points;
  final List<bool> activates;
  final int volume;
  final int sumPointsFirstPlayer;
  final int sumPointsSecondPlayer;

  const ResultPage({
    Key? key,
    required this.rounds,
    required this.points,
    required this.volume,
    required this.activates,
    required this.sumPointsFirstPlayer,
    required this.sumPointsSecondPlayer
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ResultPageState(
      rounds: rounds,
      points: points,
      volume: volume,
      activates: activates,
      sumPointsFirstPlayer: sumPointsFirstPlayer,
      sumPointsSecondPlayer: sumPointsSecondPlayer,
    );
  }
}

class _ResultPageState extends State<ResultPage> {
  final int rounds;
  final List<int> points;
  final List<bool> activates;
  final int volume;
  final int sumPointsFirstPlayer;
  final int sumPointsSecondPlayer;

  final apiKey = "AIzaSyBT5zRAya9owQehjMO8Vfc2H6xfa_wW3iY";
  String analysis = "Генерация";

  _ResultPageState({
    required this.rounds,
    required this.points,
    required this.volume,
    required this.activates,
    required this.sumPointsFirstPlayer,
    required this.sumPointsSecondPlayer
  });

  @override
  void initState() {
    super.initState();
    generateAnalysis();
    Box<ResultDetail> gameBox = Provider.of<Box<ResultDetail>>(context);
    ResultDetail resultDetail = ResultDetail(
        rounds: this.rounds,
        volume: this.volume,
        sumPointsFirstPlayer: sumPointsFirstPlayer,
        sumPointsSecondPlayer: sumPointsSecondPlayer,
        time: DateTime.now()
    );
    gameBox.put(0, resultDetail);
    MongoDB.insert(resultDetail);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Игра", style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: const Align(
                  alignment: Alignment.topCenter,
                  child: Text("Result",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700
                      )),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DataTable(columns: [
                      DataColumn(label: Text("Страна")),
                      DataColumn(label: Text("Очки")),
                      DataColumn(label: Text("Статус"))
                    ], rows: [
                      DataRow(cells: [
                        DataCell(Text("1")),
                        DataCell(Text("${sumPointsFirstPlayer}")),
                        DataCell(Text(sumPointsFirstPlayer > sumPointsSecondPlayer
                            ?
                        "won" : "lost"))
                      ]),
                      DataRow(cells: [
                        DataCell(Text("2")),
                        DataCell(Text("${sumPointsSecondPlayer}")),
                        DataCell(Text(sumPointsFirstPlayer < sumPointsSecondPlayer
                            ?
                        "won" : "lost"))
                      ])
                    ]),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      padding: EdgeInsets.all(10),
                      child: Text(
                          "Анализ: $analysis",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                          )
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IntroPage())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.indigo
                      ),
                      child: Text(
                        "Начать заново",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                        ),
                      )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void generateAnalysis() async {
    String prompt;
    prompt = """
      Проведи анализ игры "Дилемма заключенного". первый игрок получил 
      $sumPointsFirstPlayer очков, а второй $sumPointsSecondPlayer очков. 
      """;

    for (int i = 0; i < activates.length; i += 2) {
      prompt += "Первый игрок сделал вот такие ходы: ${activates[i] ? "Обманул" : "Сотрудничал"}.\n";
    }

    for (int i = 1; i < activates.length; i += 2) {
      prompt += "А второй игрок сделал такие ходы: ${activates[i] ? "Обманул" : "Сотрудничал"}.\n";
    }

    prompt +=
    """
    Посоветуй как можно лучше сыграть. Как этот результат можно связать со странами
    у которых недостаточно водных ресурсов. Твой анализ не должен первышать 100 слов.
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
      analysis = response.text!;
    });
  }
}