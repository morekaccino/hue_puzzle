import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color bg = const Color(0xff1d1d1d);
  Color? destinationColor, sourceColor;

  List<List<Color>> colorMatrix = [];

  List<List<Widget>> fieldMatrix = [];

  void makeColors(int row, int col) {
    for (int i = 0; i < row; i++) {
      var temp = <Color>[];
      for (int j = 0; j < col; j++) {
        Color rndColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0);
        temp.add(rndColor);
      }
      colorMatrix.add(temp);
    }
  }



  Widget makeWidgets() {
    var colTemp = <Widget>[];
    for (int idx = 0; idx < colorMatrix.length; idx++) {
      var rowTemp = <Widget>[];
      for (int idy = 0; idy < colorMatrix[0].length; idy++) {
        rowTemp.add(Expanded(
          child: Container(
            color: colorMatrix[idx][idy],
          ),
        ));
      }
      colTemp.add(Expanded(
        child: Row(
          children: rowTemp,
        ),
      ));
    }
    return Column(
      children: colTemp,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeColors(10, 5);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        color: bg,
        child: makeWidgets(),
      ),
    );
  }
}
