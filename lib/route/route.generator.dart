import 'package:flutter/material.dart';
import 'package:online_reservation/Presentation/Modules/Screens/first.screen.dart';
import 'package:online_reservation/Presentation/Modules/Screens/second.screen.dart';
import 'package:online_reservation/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case MyHomePage.screen_id:
        return MaterialPageRoute(builder: (_) => const FirstScreen());
      case FirstScreen.screen_id:
        return MaterialPageRoute(builder: (_) => const FirstScreen());
      case SecondScreen.screen_id:
        return MaterialPageRoute(builder: (_) => const SecondScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: "Home"));
    }
  }
}
