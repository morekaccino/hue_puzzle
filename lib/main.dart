import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color bg = const Color(0xff1d1d1d);
  int rowCount = 10, colCount = 5;

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

  Widget makeWidgets(
      {required double screenWidth, required double screenHeight}) {
    double height = screenHeight / rowCount;
    double width = screenWidth / colCount;
    var colTemp = <Widget>[];
    for (int idx = 0; idx < colorMatrix.length; idx++) {
      var rowTemp = <Widget>[];
      for (int idy = 0; idy < colorMatrix[0].length; idy++) {
        if ((idx == 0 || idx == colorMatrix.length - 1) &&
            (idy == 0 || idy == colorMatrix[0].length - 1)) {
          rowTemp.add(Expanded(
            child: Container(color: colorMatrix[idx][idy]),
          ));
        } else {
          rowTemp.add(Expanded(
            child: Draggable<List<int>>(
              data: <int>[idx, idy],
              child: Container(
                color: colorMatrix[idx][idy],
                child: DragTarget<List<int>>(
                  onAccept: (indexes) {
                    int i = indexes[0], j = indexes[1];
                    Color tempColor = colorMatrix[i][j];
                    colorMatrix[i][j] = colorMatrix[idx][idy];
                    colorMatrix[idx][idy] = tempColor;

                    setState(() {});
                  },
                  builder: (context, candidateData, rejectedData) {
                    // if (candidateData.length > 0) {
                    //   try {
                    //     int i = candidateData[0]![0], j = candidateData[0]![1];
                    //     return Container(
                    //       color: colorMatrix[i][j],
                    //     );
                    //   } finally {}
                    // }
                    // return Container(
                    //   color: Colors.transparent,
                    // );
                    return Container(
                      color: colorMatrix[idx][idy],
                    );
                  },
                ),
              ),
              feedback: Container(
                width: width,
                height: height,
                color: colorMatrix[idx][idy],
              ),
              childWhenDragging: Container(
                width: 100,
                height: 100,
                color: const Color(0xff1d1d1d),
              ),
            ),
          ));
        }
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
    makeColors(rowCount, colCount);
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Container(
      color: bg,
      child: makeWidgets(screenHeight: screenheight, screenWidth: screenwidth),
    );
  }
}
