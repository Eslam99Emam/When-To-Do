import 'package:When_to_do/main.dart';
import 'package:flutter/material.dart';
import 'package:When_to_do/screens/SignIn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  @override
  void initState() {
    super.initState();
    try {
      supabase.auth.signOut(scope: SignOutScope.global);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Signin();
  }
}
