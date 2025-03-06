import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memento/credential.dart';

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
            return HomePage(hostID: Credential.HOST_UID_FUAD);
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