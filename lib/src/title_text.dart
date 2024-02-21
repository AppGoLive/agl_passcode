import 'package:flutter/material.dart';

var title = 'Basic App';

double textSize = 18;

class TitleText extends StatelessWidget {
  const TitleText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: textSize,
      ),
    );
  }
}
