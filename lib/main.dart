import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_e_commerce/screens/welcomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hebnewocxngrvbcomtfp.supabase.co', // استبدليها برابط مشروعك
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhlYm5ld29jeG5ncnZiY29tdGZwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzAyODY1NTQsImV4cCI6MjA0NTg2MjU1NH0._sFwv3l73LELBtWl2o4-V15_Ah2JVzuxzHXjsAnzm9c', // استبدليها بالمفتاح العام لمشروعك
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Supabase',
      home: Welcomepage(),
    );
  }
}
