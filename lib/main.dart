//created by Suthura


import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:folk/providers/EventProvider.dart';
import 'package:folk/providers/chatGroupProvider.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:folk/pages/SplashScreen.dart';
import 'package:folk/providers/AppBarProvider.dart';
import 'package:folk/providers/AuthProvider.dart';
import 'package:folk/providers/ConverstionProvider.dart';
import 'package:folk/providers/DateProvider.dart';
import 'package:folk/providers/NotificationProvider.dart';
import 'package:folk/providers/PostProvider.dart';
import 'package:folk/providers/PeerProfileProvider.dart';
import 'package:folk/providers/Theme_provider.dart';
import 'package:folk/utils/Constants.dart';

import 'app_localizations.dart';

void main() {
  //set up providers
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(OverlaySupport(
    child: MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider(isLightTheme: true)),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => DateProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AppBarProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NotificationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PostProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ConversionProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => EventProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PeerProfileProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ChatGroupProvider(),
      ),
    ], child: MyApp()),
  ));
}

String getAppId() {
  if (Platform.isIOS) {
    return Constants.ADMOB_APP_ID_IOS;
  } else if (Platform.isAndroid) {
    return Constants.ADMOB_APP_ID_ANDROID;
  }
  return null;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //set up theme provider with listen true to rebuild app when theme change
    //by default listen is true
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: themeProvider.getThemeData.backgroundColor,
        statusBarIconBrightness:
            themeProvider.getThemeData.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark));
    return MaterialApp(
      supportedLocales: [Locale('en'), Locale('it')],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          print(supportedLocale.languageCode);
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: themeProvider.getThemeData,
      home: SplashScreen(),
      title: 'Folk',
      debugShowCheckedModeBanner: false,
    );
  }
}
