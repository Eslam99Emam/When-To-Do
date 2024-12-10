/// ignore_for_file: prefer_const_constructors

import 'package:When_to_do/pages/home.dart';
import 'package:When_to_do/pages/sign.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jzsvzozjqhpulanodwzk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp6c3Z6b3pqcWhwdWxhbm9kd3prIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyMTcwOTAsImV4cCI6MjA0Nzc5MzA5MH0.ufTKwpRhLGUlCXIVRWh94YZmWR_6Nb9DUtnaMwkiiVU',
  );
  runApp(const MyApp());
}

SupabaseClient supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "When\nTo-Do",
      initialRoute:
          supabase.auth.currentUser.runtimeType == Null ? '/sign' : '/home',
      routes: {
        "/home": (context) => MyHomePage(),
        "/sign": (context) => SignPage(),
      },
    );
  }
}
