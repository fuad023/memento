import 'package:flutter/material.dart';
import 'package:memento/pages/anon_login_page.dart';
import 'package:memento/pages/code_login_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showAnonLogin = true;

  void toggleLogin() {
    setState(() {
      showAnonLogin = !showAnonLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showAnonLogin 
    ? AnonLoginPage(onTap: toggleLogin)
    : CodeLoginPage(onTap: toggleLogin);
  }
}