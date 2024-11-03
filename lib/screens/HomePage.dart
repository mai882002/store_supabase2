import 'package:flutter/material.dart';
import 'package:supabase_e_commerce/screens/ProfilePage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const String routeName = '/Homepage';

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffB81736),
                Color(0xff2B1836),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffB81736), // اللون الأساسي
              padding: const EdgeInsets.symmetric(vertical: 15.0), // حشوة الزر
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // شكل الزر
              ),
            ),
            onPressed: () {
              // التنقل إلى صفحة Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            child: const Text(
              'Go to Profile Page',
              style: TextStyle(
                fontSize: 18, // حجم الخط
                color: Colors.white, // لون النص
              ),
            ),
          ),
        ),
      ),
    );
  }
}
