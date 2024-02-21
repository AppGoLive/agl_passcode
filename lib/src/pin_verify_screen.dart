import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'constants.dart';
import 'dart:convert';
import 'package:agl_passcode/src/strings.dart';
import 'package:agl_passcode/src/title_text.dart';

List<String> enteredOtp = List.filled(4, '', growable: false);

class PinVerifyScreen extends StatefulWidget {
  const PinVerifyScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _OtpState();
  }
}

class _OtpState extends State<PinVerifyScreen> {
  static const platform = MethodChannel(channelName);
  bool isVisible = false;
  String message = "";
  var otp = "";
  ThemeMode themeMode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    getIntentData();
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          popScreen(context);
        },
        child: MaterialApp(
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
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(Strings.verificationScreenTitle,
                            style: TextStyle(
                                fontSize: 38, fontWeight: FontWeight.bold)),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Container(
                    //   width: 200,
                    //   height: 200,
                    //   decoration: BoxDecoration(
                    //     color: Colors.deepPurple.shade50,
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: Image.asset(
                    //     'assets/images/illustration-3.png',
                    //   ),
                    // ),

                    const SizedBox(
                      height: 100,
                    ),

                    const TitleText(Strings.enterVerificationText),

                    const SizedBox(
                      height: 28,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _textFieldOTP(
                                  first: true,
                                  last: false,
                                  index: 0,
                                  context: context),
                              _textFieldOTP(
                                  first: false,
                                  last: false,
                                  index: 1,
                                  context: context),
                              _textFieldOTP(
                                  first: false,
                                  last: false,
                                  index: 2,
                                  context: context),
                              _textFieldOTP(
                                  first: false,
                                  last: true,
                                  index: 3,
                                  context: context),
                            ],
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                var otpNotFilled = false;
                                otp = "";
                                for (var element in enteredOtp) {
                                  if (element.isNotEmpty) {
                                    otp = otp + element;
                                  } else {
                                    otpNotFilled = true;
                                  }
                                }
                                if (otpNotFilled) {
                                  setState(() {
                                    message = "Not valid code";
                                  });
                                } else {
                                  setState(() {
                                    message = "";
                                    isVisible = true;
                                  });
                                  sendData(otp);
                                }
                                //popScreen(context);
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<
                                        Color>(
                                    Theme.of(context).colorScheme.onPrimary),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blueAccent),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  Strings.verifyBtnTxt,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Visibility(
                            visible: isVisible,
                            child: const CircularProgressIndicator(
                              backgroundColor: Colors.redAccent,
                              valueColor: AlwaysStoppedAnimation(Colors.green),
                              strokeWidth: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const Text(
                      "Didn't you receive any code?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    GestureDetector(
                        onTap: () {
                          sendForgotPwdData(true);
                          setState(() {
                            message = "";
                          });
                        },
                        onLongPress: () {},
                        child: const Text(
                          "Resend New Code",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        )),

                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _textFieldOTP(
      {required bool first,
      last,
      required int index,
      required BuildContext context}) {
    return SizedBox(
      width: 60,
      height: 70,
      child: TextField(
        textInputAction: TextInputAction.next,
        autofocus: true,
        onChanged: (value) {
          FocusScope.of(context).nextFocus();
          enteredOtp[index] = value;
        },
        showCursor: false,
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void popScreen(BuildContext context) {
    SystemNavigator.pop();
  }

  void getIntentData() {
    platform.setMethodCallHandler(_receiveFromAndroidHost);
  }

  Future<void> _receiveFromAndroidHost(MethodCall call) async {
    String isVerified = "";
    try {
      if (call.method == methodName) {
        final String data = call.arguments;
        isVerified = jsonDecode(data)["verify"];

        if (isVerified == "success") {
          setState(() {
            isVisible = false;
          });

          Navigator.pushReplacementNamed(context, '/set_passcode');
        } else {
          setState(() {
            message = "Not valid code";
            isVisible = false;
          });
        }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('PasscodeScreen ::PlatformException ====> $e');
      }
    }
  }

  Future<void> sendData(text) async {
    try {
      setState(() {
        message = "";
      });

      await platform.invokeMethod('jsonData', {"isVerify": text});
      otp = "";
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error caught in sendData: $e');
      }
    }
  }

  Future<void> sendForgotPwdData(text) async {
    try {
      setState(() {
        message = "";
      });
      await platform.invokeMethod('jsonData', {"isForgotPwd": text});
      otp = "";
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error caught in sendData: $e');
      }
    }
  }
}
