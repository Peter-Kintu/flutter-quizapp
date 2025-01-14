// ignore_for_file: unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/views/welcome_screen.dart';
import 'package:quizapp/utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 37, 37, 37),
        primaryColor: const Color(0xFF46A0AE),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF00FFCB),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}
