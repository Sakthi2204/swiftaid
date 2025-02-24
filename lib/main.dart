import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'user_selection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwiftAid',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: UserSelectionScreen(), // Now shows the user selection screen first
    );
  }
}
