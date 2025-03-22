import 'package:flutter/material.dart';
import 'package:memento/services/auth/auth_service.dart';

class AnonLoginPage extends StatefulWidget {
  final void Function()? onTap;

  const AnonLoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<AnonLoginPage> createState() => _AnonLoginPageState();
}

class _AnonLoginPageState extends State<AnonLoginPage> {
  bool isTapped = false;

  void anonLogin() async {
    try {
      setState(() => isTapped = true);
      final authService = AuthService();
      await authService.signUpAnon();
    }

    catch (e) {
      setState(() => isTapped = false);
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isTapped
        ? CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)
        : Column(
          children: [
            Expanded(child: Container()),
            Expanded(child: _initiateChat()),
            Expanded(child: _useCode(onTap: widget.onTap)),
          ],
        ),
      ),
    );
  }

  Widget _initiateChat() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: anonLogin,
            child: Text(
              "Tap to initiate memento ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
                fontSize: 16.0,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12.0,
          )
        ],
      ),
    );
  }

 Widget _useCode({
  required void Function()? onTap,
 }) {
  return GestureDetector(
    onTap: onTap,
    child: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Pick up from where you left off?",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            " Use code..",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
 }
}