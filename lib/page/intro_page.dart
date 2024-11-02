import 'package:flutter/material.dart';
import 'package:reservoir/page/game_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IntroPageState();
  }
}

class _IntroPageState extends State<IntroPage> {
  late int volume;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Игра", style: TextStyle(color: Colors.white),),
            centerTitle: true,
            backgroundColor: Colors.indigo,
          ),
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 25),
                        child: Text(
                          "Первоначальная настройка",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          onChanged: (text) {
                            volume = int.parse(text);
                          },
                          decoration: const InputDecoration(
                            labelText: "Введите обьем воды",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GamePage(volume: volume))
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.indigo
                          ),
                          child: Text(
                            "Играть",
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
              )
          )
      ),
    );
  }
}