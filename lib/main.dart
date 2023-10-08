import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'homePage.dart';


main() {
  return runApp(MyApp());
} //ef

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  Locale _locale = Locale('en', ''); // Default language is English

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kinokuniya map',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('th', 'TH'), // Thai
        // Add more supported locales as needed
      ],
      locale: _locale, // Set the current locale
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        changeLanguage : _changeLanguage),
    );
  }
}
