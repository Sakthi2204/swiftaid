import 'package:flutter/material.dart';
import 'package:flutter_radar/flutter_radar.dart';
import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Radar.initialize("prj_test_pk_56e8168df8db7ce3c5e065f98ac5530b8aa9ef83");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Radar Tracking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}
