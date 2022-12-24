import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_puzzle/main.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  int rows = 10, cols = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: rows.toString(),
                onChanged: (val) {
                  rows = int.parse(val);
                },
                decoration: const InputDecoration(
                  labelText: "Number of Rows",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],

              ),
              TextFormField(
                initialValue: cols.toString(),
                onChanged: (val) {
                  cols = int.parse(val);
                },
                decoration: const InputDecoration(
                  labelText: "Number of Columns",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(
                        rows: rows,
                        cols: cols,
                      ),
                    ),
                  );
                },
                child: const Text("Play!"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
