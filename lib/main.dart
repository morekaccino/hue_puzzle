import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color bg = const Color(0xff1d1d1d);
  int rowCount = 3, colCount = 2;

  bool startVisibility = true, winVisibility = false, makeColorLock = false;

  List<List<Color?>> colorMatrix = [], answer = [];

  List<List<Widget>> fieldMatrix = [];

  void makeColors(int row, int col) {
    colorMatrix = [];
    answer = [];
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
    }

    // Deep copy of answer
    for (int i = 0; i < row; i++) {
      List<Color> tempRow = <Color>[];
      for (int j = 0; j < col; j++) {
        // Color tempColor = Color(colorMatrix[i][j]!.value);
        tempRow.add(colorMatrix[i][j]!);
      }
      answer.add(tempRow);
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
    winVisibility = true;
    makeColorLock = false;
    return true;
  }

  void shuffleColors() {
    var r = math.Random();
    for (int i = 0; i < 2 * rowCount * colCount; i++) {
      int i = r.nextInt(rowCount), j = r.nextInt(colCount);
      int x = r.nextInt(rowCount), y = r.nextInt(colCount);
      if (((i == 0 || i == rowCount - 1) && (j == 0 || j == colCount - 1)) ||
          ((x == 0 || x == rowCount - 1) && (y == 0 || y == colCount - 1))) {
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
            child: Container(
              color: colorMatrix[idx][idy],
              padding: const EdgeInsets.all(0),
            ),
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

                    setState(() {
                      check();
                    });
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
  }

  @override
  void didChangeDependencies() {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (math.max(screenheight, screenwidth) < 1000) {
      rowCount = (screenheight / 150).ceil();
      colCount = (screenwidth / 150).ceil();
    }
    else {
      rowCount = (screenheight / 250).ceil();
      colCount = (screenwidth / 250).ceil();
    }
    if (makeColorLock == false) {
      makeColors(rowCount, colCount);
      makeColorLock = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          color: bg,
          child:
              makeWidgets(screenHeight: screenheight, screenWidth: screenwidth),
        ),
        // Start
        Visibility(
          visible: startVisibility,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 700),
              width: screenwidth,
              height: screenheight,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.black26),
                  ),
                  child: Text(
                    "PLAY!",
                    style:
                        GoogleFonts.monoton(fontSize: 90, color: Colors.black),
                  ),
                  onPressed: () async {
                    startVisibility = !startVisibility;
                    setState(() {});
                    await Future.delayed(const Duration(milliseconds: 1000));
                    shuffleColors();
                    setState(() {});
                  },
                ),
              )),
        ),
        // Win
        Visibility(
          visible: winVisibility,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              width: screenwidth,
              height: screenheight,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.black26),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "WOW!",
                          style:
                          GoogleFonts.monoton(fontSize: 90, color: Colors.black),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "You Are Good At This!",
                              textAlign: TextAlign.center,
                              style:
                              GoogleFonts.monoton(fontSize: 45, color: Colors.black),
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    winVisibility = !winVisibility;
                    setState(() {});
                    makeColors(rowCount, colCount);
                    setState(() {});
                    await Future.delayed(const Duration(milliseconds: 1000));
                    shuffleColors();
                    setState(() {});
                  },
                ),
              )),
        ),
      ],
    );
  }
}
