import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:agl_passcode/src/keypad_button.dart';
import 'package:agl_passcode/src/pin_circle.dart';
import 'package:agl_passcode/src/secrets_config.dart';
import 'package:agl_passcode/src/title_text.dart';
import 'package:agl_passcode/src/secret_config.dart';
import 'package:agl_passcode/src/strings.dart';

bool isInConfirmMode = false;

bool pinsMatched = false;

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen(
      {super.key,
      required this.isCreate,
      required this.onConfirm,
      required this.pin,
      required this.isDarkTheme,
      required this.isFromConfirm});

  final bool isCreate;

  final bool isFromConfirm;

  final String pin;

  final bool isDarkTheme;

  final Function(bool isAuthenticated, String passcode) onConfirm;

  @override
  State<PasscodeScreen> createState() {
    return _PasscodeScreenState();
  }
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  @override
  void didUpdateWidget(covariant PasscodeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isCreate) {
      correctPin = widget.pin;
    }
  }

  @override
  void initState() {
    correctPin = widget.pin;

    if (widget.isCreate) {
      screenTitle = Strings.setPasscodeText;
      toolbarTitle = Strings.createPasscodeText;
    } else {
      screenTitle = Strings.enterPasscodeText;
    }

    if (widget.isFromConfirm) {
      screenTitle = Strings.reEnterPasscodeText;
      toolbarTitle = Strings.changePasscodeText;
    }
    if (widget.isDarkTheme) {
      themeMode = ThemeMode.dark;
    } else {
      themeMode = ThemeMode.light;
    }
    super.initState();
  }

  TextEditingController tController = TextEditingController();
  String correctPin = "";
  String input = '';
  String confirmInput = '';
  bool wrongPin = false;
  String screenTitle = '';
  String setPin = '';
  String toolbarTitle = Strings.passcodeScreentTitle;

  ThemeMode themeMode = ThemeMode.dark;

  void onKeyboardButtonClicked(String val) {
    wrongPin = false;
    if (val == "X") {
      if (tController.text.isNotEmpty) {
        tController.text =
            tController.text.substring(0, tController.text.length - 1);
      }
    } else if (val == Strings.resetBtnText) {
      tController.text = '';
      widget.onConfirm(false, Strings.resetBtnText);
    } else if (val == Strings.forgotPwdText) {
      tController.text = '';
      widget.onConfirm(false, Strings.forgotPwdText);
    } else {
      if (tController.text.length < 4) {
        tController.text = tController.text + val;
      }
      if (tController.text.length == 4) {
        if (widget.isCreate == true) {
          setPin = tController.text;
        } else {
          if (correctPin == tController.text) {
            if (kDebugMode) {
              widget.onConfirm(true, correctPin);
            }
          } else {
            wrongPin = true;
            tController.text = "";
            widget.onConfirm(false, correctPin);
          }
        }
      }
    }
    setState(() {
      input = tController.text;
      if (widget.isCreate && input.length == 4) {
        if (isInConfirmMode) {
          if (input == correctPin) {
            pinsMatched = true;
            isInConfirmMode = false;
            widget.onConfirm(true, correctPin);
            tController.text = "";
            wrongPin = false;
            input = "";
          } else {
            tController.text = "";
            wrongPin = true;
            input = "";
            //widget.onConfirm(false, correctPin);
          }
        } else {
          screenTitle = "Confirm Passcode";
          correctPin = setPin;
          tController.text = "";
          input = "";
          isInConfirmMode = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(18, 18, 18, 1),
              secondary: Color.fromRGBO(18, 18, 18, 1))),

      /* Dark theme settings */
      darkTheme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
            primary: Colors.white, secondary: Colors.white),
      ),
      themeMode: themeMode,
      home: Scaffold(
          body: SafeArea(
              child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(toolbarTitle,
                    style: const TextStyle(
                        fontSize: 38, fontWeight: FontWeight.bold))),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                padding: const EdgeInsets.all(16),
                onPressed: () {
                  widget.onConfirm(false, Strings.closeBtnText);
                },
                icon: const Icon(Icons.close)),
          ),
          Center(
              child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleText(screenTitle),
                const SizedBox(
                  height: 20,
                ),
                SecretsWithShakingAnimation(
                  config: SecretsConfig(
                      secretConfig: SecretConfig(
                          borderColor: Theme.of(context).colorScheme.onPrimary,
                          enabledColor:
                              Theme.of(context).colorScheme.onPrimary)),
                  length: 4,
                  input: ValueNotifier(input),
                  verifyStream: Stream.value(tController.text == correctPin),
                ),
                Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: wrongPin,
                    child: const Text(Strings.wrongPasscodeMsg,
                        style: TextStyle(color: Colors.redAccent))),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeypadButton(
                        buttonText: Strings.btn1,
                        onClick: (val) {
                          onKeyboardButtonClicked(
                            val,
                          );
                        }),
                    KeypadButton(
                        buttonText: Strings.btn2,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                    KeypadButton(
                        buttonText: Strings.btn3,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeypadButton(
                        buttonText: Strings.btn4,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                    KeypadButton(
                        buttonText: Strings.btn5,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                    KeypadButton(
                        buttonText: Strings.btn6,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeypadButton(
                        buttonText: Strings.btn7,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                    KeypadButton(
                        buttonText: Strings.btn8,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                    KeypadButton(
                        buttonText: Strings.btn9,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: false,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(24)),
                          child: const Text(Strings.btnC)),
                    ),
                    KeypadButton(
                        buttonText: Strings.btn0,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                    KeypadButton(
                        buttonText: Strings.btnX,
                        onClick: (val) {
                          onKeyboardButtonClicked(val);
                        }),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: input.isNotEmpty,
                    child: TextButton(
                        onPressed: () {
                          onKeyboardButtonClicked(Strings.resetBtnText);
                        },
                        child: const Text(Strings.resetBtnText))),
                Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: toolbarTitle == Strings.passcodeScreentTitle ||
                        toolbarTitle == Strings.changePasscodeText,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextButton(
                                onPressed: () {
                                  onKeyboardButtonClicked(
                                      Strings.forgotPwdText);
                                },
                                child: const Text(Strings.forgotPwdText))))),
              ],
            ),
          )),
        ],
      ))),
    );
  }
}
