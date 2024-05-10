import 'package:amp_studenthub/utilities/local_storage.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _appLocale = const Locale('en');

  Locale get appLocal => _appLocale;

  fetchLocale() async {
    var storage = await LocalStorage.init();
    storage = LocalStorage.instance;
    if (storage.getString(key: StorageKey.languageCode) != null &&
        storage.getString(key: StorageKey.languageCode) != "") {
      _appLocale = const Locale('ru');
      return Null;
    }

    _appLocale = Locale(storage.getString(key: StorageKey.languageCode)!);
    return Null;
  }

  Future<void> updateLanguage(Locale type) async {
    var storage = await LocalStorage.init();
    storage = LocalStorage.instance;
    if (_appLocale == type) {
      return;
    }

    if (type == const Locale('en')) {
      _appLocale = const Locale('en');
      await storage.saveString(key: StorageKey.languageCode, value: 'en');
    } else {
      _appLocale = const Locale('vi');
      await storage.saveString(key: StorageKey.languageCode, value: 'vi');
    }
    notifyListeners();
  }
}
