import 'package:flutter/material.dart';
import 'package:agl_passcode/passcode_screen.dart';
import 'package:agl_passcode/src/pin_verify_screen.dart';
import 'package:agl_passcode/lock_screen_helper.dart';
import 'package:agl_passcode/strings.dart';

var passcode = "";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Passcode',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const LaunchScreen(),
          '/set_passcode': (context) => LockScreenHelper(
              isCreate: true, isEdit: false, isFromChangePasscode: false),
          '/enter_passcode': (context) => LockScreenHelper(
              isCreate: false, isEdit: false, isFromChangePasscode: false),
          '/change_passcode': (context) => LockScreenHelper(
              isCreate: false, isEdit: true, isFromChangePasscode: true),
          '/forgot_password': (context) => const PinVerifyScreen(),
        });
  }
}

void handleForgotPassword(String pin, BuildContext context) {
  if (pin == Strings.forgotPwdText) {
    Navigator.pushReplacementNamed(context, '/forgot_password');
  }
}

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LockScreenHelper(
                            isCreate: true,
                            isEdit: false,
                            isFromChangePasscode: false)),
                  );
                },
                child: const Text('Set Passcode')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PasscodeScreen(
                              isCreate: false,
                              isFromConfirm: false,
                              onConfirm: (isAuthenticated, pin) {
                                if (isAuthenticated) {
                                  Navigator.pop(context);
                                } else {}
                                handleForgotPassword(pin, context);
                              },
                              pin: passcode,
                              isDarkTheme: true,
                            )),
                  );
                },
                child: const Text('Unlock')),
          ],
        ),
      ),
    )));
  }
}
