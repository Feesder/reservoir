import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:reservoir/model/result_detail.dart';

class MongoDB {
  static var db, resultCollection;
  static final String URI = "mongodb+srv://qop6261:Nwtc3phHCirc3kLB@cluster.j8hhk.mongodb.net/?retryWrites=true&w=majority&appName=Cluster";
  static final String RESULT_CONNECTION = "results";

  static connect() async {
    db = await Db.create(URI);
    await db.open();
    resultCollection = db.collection(RESULT_CONNECTION);
    debugPrint(resultCollection.toString());
  }

  static void insert(ResultDetail resultDetail) async {
    await resultCollection.insertOne(resultDetail.toJson());
  }
}