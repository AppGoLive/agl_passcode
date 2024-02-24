import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'package:agl_passcode/passcode_screen.dart';
import 'package:agl_passcode/strings.dart';
import 'package:agl_passcode/src/secure_storage.dart';
import 'package:flutter/foundation.dart';

var inChangePasscode = false;

/// LockScreenHelper is used to display passcode screen and save the passcode
/// [isCreate] is used to create new passcode
/// [isEdit] is used for modifying the passcode
/// [isFromChangePasscode] to check whether it is change passcode

//ignore: must_be_immutable
class LockScreenHelper extends StatefulWidget {
  LockScreenHelper(
      {super.key,
      required this.isCreate,
      required this.isEdit,
      required this.isFromChangePasscode});

  bool isCreate;
  bool isEdit;
  bool isFromChangePasscode;

  @override
  LockScreenHelperState createState() => LockScreenHelperState();
}

class LockScreenHelperState extends State<LockScreenHelper> {
  @override
  void initState() {
    getIntentData();
    if (widget.isEdit) {
      widget.isCreate = false;
      getSecurePasscode();
    } else {
      if (!widget.isCreate) {
        getSecurePasscode();
      } else {
        _passcode = '';
      }
    }

    super.initState();
  }

  String _passcode = '';

  static const platform = MethodChannel(channelName);

  String jsonData = '';

  late BuildContext mContext;

  void getIntentData() {
    platform.setMethodCallHandler(_receiveFromAndroidHost);
  }

  Future<void> _receiveFromAndroidHost(MethodCall call) async {
    try {
      if (call.method == methodName) {
        //final String data = call.arguments;
        //final screenName = jsonDecode(data)[SCREEN_NAME_KEY];
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('PasscodeScreen ::PlatformException ====> $e');
      }
    }
  }

  Future<void> sendData(text, type) async {
    try {
      await platform
          .invokeMethod('jsonData', {"isPasscodeSet": text, "type": type});
      inChangePasscode = false;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error caught in sendData: $e');
      }
    }
  }

  Future<void> sendForgotPwdData(text) async {
    try {
      await platform.invokeMethod('jsonData', {"isForgotPwd": text});
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error caught in sendData: $e');
      }
    }
  }

  void setSecurePasscode(String pin) {
    SecureStorage().writeSecureData("passcode", pin);
  }

  getSecurePasscode() {
    SecureStorage().readSecureData('passcode').then((value) {
      setState(() {
        _passcode = value.toString();
      });
    });
  }

  void popScreen(BuildContext context) {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;

    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {},
        child: PasscodeScreen(
          isCreate: widget.isCreate,
          isFromConfirm: widget.isFromChangePasscode,
          onConfirm: (isAuthenticated, pin) {
            handleForgotPassword(pin, context);
            if (widget.isEdit) {
              if (isAuthenticated) {
                inChangePasscode = true;
                widget.isEdit = false;
                widget.isCreate = true;
                Navigator.pushReplacementNamed(context, '/set_passcode');
              }
              handleCloseButton(pin, context);
            } else {
              if (isAuthenticated) {
                if (widget.isCreate) {
                  var type = "";
                  if (inChangePasscode) {
                    type = Strings.passcodeChanged;
                  } else {
                    type = Strings.passcodeSet;
                  }
                  sendData(true, type);
                  setSecurePasscode(pin);
                } else {
                  sendData(true, "");
                }
                popScreen(context);
              }
              handleCloseButton(pin, context);
            }
          },
          pin: _passcode,
          isDarkTheme: true,
        ));
  }

  void handleCloseButton(String pin, BuildContext context) {
    if (pin == Strings.closeBtnText) {
      sendData(false, "");
      popScreen(context);
    }
  }

  void handleForgotPassword(String pin, BuildContext context) {
    if (pin == Strings.forgotPwdText) {
      sendForgotPwdData(true);
      // popScreen(context);
      Navigator.pushReplacementNamed(context, '/forgot_password');
    }
  }
}
