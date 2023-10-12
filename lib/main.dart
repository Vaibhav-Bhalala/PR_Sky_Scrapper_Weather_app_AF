import 'package:flutter/material.dart';
import 'package:pr_weather_app_af/views/Screens/Home_Screen.dart';
import 'package:pr_weather_app_af/views/Screens/Splash_Screen.dart';
import 'package:pr_weather_app_af/views/Screens/home_screen_ios.dart';
import 'package:pr_weather_app_af/views/Screens/intro_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'Model/app_model.dart';
import 'Model/theme_model.dart';
import 'Providers/app_provider.dart';
import 'Providers/connectivity_provider.dart';
import 'Providers/theme_provider.dart';
import 'Providers/weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool appTheme = prefs.getBool("isDark") ?? false;

  var isvisited;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(
            appModel: AppModel(isIos: true),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(
            themeModel: ThemeModel(isDark: appTheme),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(),
        ),
      ],
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark(
          useMaterial3: true,
        ),
        themeMode: (Provider.of<ThemeProvider>(context).themeModel.isDark)
            ? ThemeMode.dark
            : ThemeMode.light,
        initialRoute: (isvisited) ? 'Splash' : '/',
        routes: {
          'HomePage': (context) => const HomePage(),
          '/': (context) => const SplashScreen(),
          'into': (context) => const intro_page(),
          'Home_ios': (context) => const Home_ios_Page(),
        },
      ),
    ),
  );
}