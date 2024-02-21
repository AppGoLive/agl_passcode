import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  final _accountNameController =
      TextEditingController(text: 'flutter_secure_storage_service');

  writeSecureData(String key, String value) async {
    await storage.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  readSecureData(String key) async {
    String value = await storage.read(
          key: key,
          iOptions: _getIOSOptions(),
          aOptions: _getAndroidOptions(),
        ) ??
        'No data found!';
    if (kDebugMode) {
      print('Data read from secure storage: $value');
    }
    return value;
  }

  deleteSecureData(String key) async {
    await storage.delete(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  IOSOptions _getIOSOptions() => IOSOptions(
        accountName: _getAccountName(),
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );

  String? _getAccountName() =>
      _accountNameController.text.isEmpty ? null : _accountNameController.text;
}
