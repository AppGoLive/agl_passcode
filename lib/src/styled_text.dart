import 'package:flutter/material.dart';

var title = 'Basic App';

double textSize = 22;

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});

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
