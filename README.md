# Flutter - Passcode Screen

This Flutter package provides an feature for creating a passcode , verify and change passcode.

## Installation

First add agl_passcode as a dependency in your pubspec.yaml file.

and then import

```dart
import 'package:agl_passcode/src/lock_screen_helper.dart';
 ```
or

```dart
import 'package:agl_passcode/src/passcode_screen.dart';
 ```

## Features

- Creating a new passcode
- Saving the passocde in secure local storage
- Validate/Unlock Passcode
- Change Passcode
- Forgot passcode & call backs
- Suppoprts Dark and Light themes


## Usage

You can easily set the new passcode , validate and change the passocde by using the following code snippets.

#### Create Passcode :
```dart
 LockScreenHelper(isCreate: true, isEdit: false, isFromChangePasscode: false);
 ```

Above code will create passcode and save the passcode in secured local storage

or

Below code provides the call backs once the new passcode is created so that user can save the passcode

```dart
  PasscodeScreen(
          isCreate: true,
          isFromChangePasscode : false,
          onConfirm: (isAuthenticated, pin) {
             // handle authentication and saving pin here
            
          },
          pin: "",
          isDarkTheme: true,
        );
 ```



#### Validate Passcode :

Passcode validation is done by getting the passcode from secure storage by using below code snippet

```dart
LockScreenHelper(isCreate: false, isEdit: false, isFromChangePasscode: false);
```
or

Using below code snippet, the passcode is validated by passing the correct passcode

```dart
  PasscodeScreen(
          isCreate: false,
          isFromChangePasscode : false,
          onConfirm: (isAuthenticated, pin) {
             // handle authentication and saving pin here
            
          },
          pin: "{correct_passcode}",
          isDarkTheme: true,
        );
 ```


#### Change Passcode :
```dart
LockScreenHelper(isCreate: false, isEdit: true, isFromChangePasscode : true),
```
or

```dart
  PasscodeScreen(
          isCreate: false,
          isFromChangePasscode : true,
          onConfirm: (isAuthenticated, pin) {
             // handle authentication and saving pin here
            
          },
          pin: "{correct_passcode}",
          isDarkTheme: true,
        );
 ```


#### Forgot Passcode :

Below code snippet used to handle the forgot passcode flow


 ```dart
  PasscodeScreen(
          isCreate: false,
          isFromChangePasscode : false,
          onConfirm: (isAuthenticated, pin) {
            
            if (pin == Strings.forgotPwdText) {

               // handle forgot passcode flow here , like launching the   new screen or any businesslogic   
            }
            
          },
          pin: "{correct_passcode}",
          isDarkTheme: true,
        );
 ```

