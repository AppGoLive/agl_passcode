import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({super.key});

  @override
  State<InputField> createState() {
    return _InputFieldState();
  }
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return const TextField(
      maxLines: 1,
    );
  }
}

//    InputField({super.key, this.textEditingController});

//   final TextEditingController? textEditingController;
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//         controller: textEditingController,
//         decoration: const InputDecoration(
//             hintText: "Enter Passcode",
//             focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(width: 1, color: Colors.redAccent))));
//   }
// }
