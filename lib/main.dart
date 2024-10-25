import 'package:flutter/material.dart';
import 'package:geminiclone/presentation/pages/home_page.dart';
import 'package:geminiclone/presentation/pages/starter_page.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'core/config/root_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StarterPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
      },
      initialBinding: RootBinding(),
    );
  }
}
