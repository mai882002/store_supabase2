import 'package:flutter/material.dart';
import 'package:supabase_e_commerce/screens/welcomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Supabase',
      home: Welcomepage(),
    );
  }
}
