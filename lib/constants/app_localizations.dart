import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'dart:async';

import 'package:flutter/services.dart';

// class AppLocalizations {
//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       _AppLocalizationsDelegate();

//   final Locale locale;

//   AppLocalizations(this.locale);

//   static AppLocalizations? of(BuildContext context) {
//     return Localizations.of<AppLocalizations>(context, AppLocalizations);
//   }

//   static Map<String, Map<String, String>> _localizedValues = {
//     'en': {
//       'title': 'My App',
//       'hello': 'Hello, World!',
//     },
//     'ar': {
//       'title': 'تطبيقي',
//       'hello': 'مرحبا بالعالم!',
//     }
//   };

//   String get title {
//     return _localizedValues[locale.languageCode]!['title'] ?? 'My App';
//   }

//   String get hello {
//     return _localizedValues[locale.languageCode]!['hello'] ?? 'Hello, World!';
//   }
// }

// class _AppLocalizationsDelegate
//     extends LocalizationsDelegate<AppLocalizations> {
//   const _AppLocalizationsDelegate();

//   @override
//   bool isSupported(Locale locale) {
//     return ['en', 'ar'].contains(locale.languageCode);
//   }

//   @override
//   Future<AppLocalizations> load(Locale locale) {
//     return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
//   }

//   @override
//   bool shouldReload(_AppLocalizationsDelegate old) => false;
// }




class AppLocalizations {
  late Locale locale;
  late Map<String, String> _valueText;
  static late AppLocalizations _instance;

  AppLocalizations(this.locale) {
    _instance = this;
  }

  static AppLocalizations get instance {
    return _instance;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      AppLocalizationsDelegate();

  Future<void> loadTranslateFile() async {
    String _langFile =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    Map<String, dynamic> _json = jsonDecode(_langFile);
    _valueText = _json.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslate(String key) {
    return _valueText[key]!;
  }
}




// class AppLocalizations {
//   late Locale locale;
//   late Map<String, String> _valueText;
//   AppLocalizations(this.locale);

//   static AppLocalizations of(BuildContext context) {
//     return Localizations.of(context, AppLocalizations);
//   }

//   static const LocalizationsDelegate<AppLocalizations> delegate =
//       AppLocalizationsDelegate();

//   Future loadTranslateFile() async {
//     String _langFile =
//         await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

//     Map<String, dynamic> _json = jsonDecode(_langFile);
//     _valueText = _json.map((key, value) => MapEntry(key, value.toString()));
//   }

//   String getTranslate(String key) {
//     return _valueText[key]!;
//   }
// }

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = AppLocalizations(locale);
    await appLocalizations.loadTranslateFile();
    return appLocalizations;
  }

  @override
  bool shouldReload(covariant AppLocalizationsDelegate old) => false;
}
