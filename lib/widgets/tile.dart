import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  Tile({Key? key, required this.idx, required this.idy}) : super(key: key);
  int idx, idy;

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Draggable<List<int>>(
      data: <int>[widget.idx, widget.idy],
      child: Container(
        width: 100,
        height: 100,
        color: colorMatrix[idx][idy],
        child: DragTarget<List<int>>(
          onAccept: (indexes) {
            int i = indexes[0], j = indexes[1];
            Color tempColor = colorMatrix[i][j];
            colorMatrix[i][j] = colorMatrix[idx][0];
            colorMatrix[idx][0] = tempColor;

            setState(() {});
          },
          builder: (context, candidateData, rejectedData) {
            if (candidateData.length > 0) {
              try {
                int i = candidateData[0]![0], j = candidateData[0]![1];
                return Container(
                  color: colorMatrix[i][j],
                  height: 100,
                  width: 100,
                );
              } finally {}
            }
            return Container(
              color: Colors.transparent,
              height: 100,
              width: 100,
            );
          },
        ),
      ),
      feedback: Container(
        width: 100,
        height: 100,
        color: colorMatrix[idx][0],
      ),
      childWhenDragging: Container(
        width: 100,
        height: 100,
        color: const Color(0xff1d1d1d),
      ),
    );
  }
}
