import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:memento/pages/home_page.dart';
import 'package:memento/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const HomePage(hostID: "Kq5C9ykBe0cPyOMHEdz12qYkmr92");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading user data.."));
          }

          // user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        }
      ),
    );
  }
}