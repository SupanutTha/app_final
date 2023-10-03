import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'homePage.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'th';
  return runApp(
    MaterialApp(
      //theme: new ThemeData(
      //primarySwatch: Colors.blue,
      //primaryColor: const Color(0xFF2196f3),
      //accentColor: const Color(0xFF2196f3),
      //canvasColor: const Color(0xFFfafafa),
      //),
      home: HomePage(),
    ),
  );
} //ef