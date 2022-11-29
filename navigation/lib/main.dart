import 'package:flutter/material.dart';
import 'package:navigation/screen/home_screen.dart';
import 'package:navigation/screen/route_three_screen.dart';
import 'package:navigation/screen/route_one_screen.dart';
import 'package:navigation/screen/route_two_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      // home: HomeScreen(),
      routes: {
        '/': (context) => HomeScreen(),
        '/one': (context) => RouteOneScreen(arguments: '123'),
        '/two': (context) => RouteTwoScreen(),
        '/three': (context) => RouteThreeScreen(),
      },
    )
  );
}
