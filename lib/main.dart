import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:reservoir/database/mongodb.dart';
import 'package:reservoir/page/intro_page.dart';
import 'model/result_detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroPage(),
    );
  }
}


// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyFirstApp());
//
// class MyFirstApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _MyFirstAppState();
//   }
// }
//
// class _MyFirstAppState extends State<MyFirstApp> {
//   late bool _loading;
//   late double _progressValue;
//
//   @override
//   void initState() {
//     _loading = false;
//     _progressValue = 0.0;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//           backgroundColor: Colors.indigo,
//           appBar: AppBar(
//             title: const Text("My first App"),
//             centerTitle: true,
//           ),
//           body: Center(
//             child: Container(
//               padding: const EdgeInsets.all(16),
//               child: _loading ?
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   LinearProgressIndicator(value: _progressValue),
//                   Text(
//                       '${(_progressValue * 100).round()}%',
//                       style: TextStyle(color: Colors.white, fontSize: 20)
//                   )
//                 ],
//               )
//               :
//               const Text(
//                   'Press button to download',
//                   style: TextStyle(color: Colors.white, fontSize: 20)
//               ),
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   _loading = !_loading;
//                   _updateProgress();
//                 });
//               },
//               child: const Icon(Icons.cloud_download)
//           ),
//         )
//     );
//   }
//
//   void _updateProgress() {
//     const second = const Duration(seconds: 1);
//     Timer.periodic(second, (Timer t) {
//       setState(() {
//         _progressValue += 0.2;
//
//         if (_progressValue.toStringAsFixed(1) == '1.0') {
//           _loading = false;
//           t.cancel();
//           _progressValue = 0;
//         }
//       });
//     });
//   }
// }