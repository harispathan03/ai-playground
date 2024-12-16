import 'package:ai_playground/pages/home_page.dart';
import 'package:ai_playground/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [
        //
      ],
      child: MaterialApp(
        title: 'AI Playground',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: darkPinkColor),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
