import 'dart:developer';

import 'package:flutter/material.dart';

int inputTimes = 0;
List<String> X = [];
List<String> O = [];

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Array of button
  final List<String> buttons = ['', '', '', '', '', '', '', '', ''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: const Text(
                        'JOGO DA VELHA',
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.black,
                            backgroundColor: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          if (inputTimes >= 8) {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return endGameModal(context, "Empate");
                                }).then((value) => {setState(() {})});
                          } else {
                            inputTimes++;
                            inputTimes % 2 == 0
                                ? {X.add('${index + 1}')}
                                : {O.add('${index + 1}')};
                          }
                        });
                        if (hasWin()) {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return endGameModal(
                                    context, "Fim de Jogo. Vitória");
                              }).then((value) => {setState(() {})});
                        }
                      },
                      buttonText: buttonText('${index + 1}'),
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  }),
            ),
          ],
        ));
  }
}

Container endGameModal(BuildContext context, String endGameText) {
  return Container(
    height: 200,
    color: Colors.amber,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(endGameText,
              style: const TextStyle(
                  fontSize: 45,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          ElevatedButton(
            child: const Text('Jogar Novamente',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            onPressed: () => resetGame(context),
          ),
        ],
      ),
    ),
  );
}

String buttonText(String input) {
  String value = '';

  if (X.contains(input)) value = 'X';
  if (O.contains(input)) value = 'O';

  return value;
}

void resetGame(BuildContext context) {
  Navigator.pop(context);
  inputTimes = 0;
  X = [];
  O = [];
}

bool hasWin() {
  return verticalWin(X) ||
      verticalWin(O) ||
      horizontalWin(X) ||
      horizontalWin(O) ||
      diagonalWin(X) ||
      diagonalWin(O);
}

bool verticalWin(List<String> array) {
  if (containsAll(['1', '4', '7'], array)) return true;
  if (containsAll(['2', '5', '8'], array)) return true;
  if (containsAll(['3', '6', '9'], array)) return true;

  return false;
}

bool horizontalWin(List<String> array) {
  if (containsAll(['1', '2', '3'], array)) return true;
  if (containsAll(['4', '5', '6'], array)) return true;
  if (containsAll(['7', '8', '9'], array)) return true;

  return false;
}

bool diagonalWin(List<String> array) {
  if (containsAll(['1', '5', '9'], array)) return true;
  if (containsAll(['3', '5', '7'], array)) return true;

  return false;
}

bool containsAll(List<String> expectedResult, List<String> clicked) {
  for (int i = 0; i < expectedResult.length; i++) {
    if (!clicked.contains(expectedResult[i])) {
      return false;
    }
  }
  return true;
}

class MyButton extends StatelessWidget {
  // declaring variables
  final color;
  final textColor;
  final String buttonText;
  final buttontapped;

  //Constructor
  MyButton(
      {this.color,
      this.textColor,
      required this.buttonText,
      this.buttontapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
        padding: const EdgeInsets.all(0.2),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(25),
          child: Container(
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
