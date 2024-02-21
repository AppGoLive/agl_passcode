import 'package:flutter/material.dart';
import 'package:agl_passcode/src/styled_text.dart';

class KeypadButton extends StatelessWidget {
  const KeypadButton({
    super.key,
    required this.buttonText,
    required this.onClick,
  });

  final String buttonText;

  final Function(String val) onClick;

  @override
  Widget build(BuildContext context) {
    if (buttonText == "X") {
      return ElevatedButton(
          onPressed: () {
            onClick(buttonText);
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), padding: const EdgeInsets.all(19)),
          child: const Icon(Icons.backspace_outlined));

      // return IconButton(
      // onPressed: () {
      //   onClick(buttonText);
      // },
      // icon: const Icon(Icons.clear));
    } else {
      return ElevatedButton(
          onPressed: () {
            onClick(buttonText);
          },
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(), padding: const EdgeInsets.all(18)),
          child: StyledText(buttonText));
    }
  }
}
