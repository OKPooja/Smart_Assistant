import 'package:flutter/material.dart';
import 'package:voice_assistant_app/pallet.dart';
import 'home_page.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Assistant App',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.backGroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.backGroundColor ,
        )
      ),
      home: const HomePage(),
    );
  }
}
