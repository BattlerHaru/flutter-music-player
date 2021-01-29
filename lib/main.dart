import 'package:flutter/material.dart';
import 'package:player_v2/src/pages/player_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'player',
      routes: {
        'player': (context) => PlayerPage(),
      },
    );
  }
}
