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
  int rowCount = 12, colCount = 25;

  List<List<Color?>> colorMatrix = [], answer = [];

  List<List<Widget>> fieldMatrix = [];

  void makeColors(int row, int col) {
    Color a = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        b = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        c = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0),
        d = Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
            .withOpacity(1.0);
    double rowStep = 1 / row;
    for (int i = 0; i < row; i++) {
      Color? startBase = Color.lerp(a, c, i * rowStep);
      Color? endBase = Color.lerp(b, d, i * rowStep);
      var temp = <Color?>[startBase];
      double colStep = 1 / col;
      for (int j = 1; j < col; j++) {
        temp.add(Color.lerp(startBase, endBase, j * colStep));
      }
      colorMatrix.add(temp);
      answer.add(temp);
    }
  }

  bool check() {
    for (int idx = 0; idx < colorMatrix.length; idx++) {
      for (int idy = 0; idy < colorMatrix[0].length; idy++) {
        if (colorMatrix[idx][idy] != answer[idx][idy]) {
          return false;
        }
      }
    }
    print("Yay!!!!");
    return true;
  }

  void shuffleColors() {
    var r = math.Random();
    for (int i = 0; i < 2 * rowCount * colCount; i++) {
      int i = r.nextInt(rowCount), j = r.nextInt(colCount);
      int x = r.nextInt(rowCount), y = r.nextInt(colCount);
      if (((i == 0 || i == rowCount - 1) && (j == 0 || j == colCount)) ||
          ((x == 0 || x == rowCount - 1) && (y == 0 || y == colCount))) {
        continue;
      }
      var temp = colorMatrix[i][j];
      colorMatrix[i][j] = colorMatrix[x][y];
      colorMatrix[x][y] = temp;
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
            child: Container(color: colorMatrix[idx][idy], padding: const EdgeInsets.all(0),),
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
                    Color? tempColor = colorMatrix[i][j];
                    colorMatrix[i][j] = colorMatrix[idx][idy];
                    colorMatrix[idx][idy] = tempColor;

                    setState(() {check();});
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
                      padding: const EdgeInsets.all(0),
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
    // shuffleColors();
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
