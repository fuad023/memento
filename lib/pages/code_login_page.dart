import 'package:flutter/material.dart';
import 'package:memento/components/my_textfield.dart';
import 'package:memento/components/my_button.dart';

import 'package:memento/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:memento/themes/theme_provider.dart';

class CodeLoginPage extends StatefulWidget {
  final void Function()? onTap;

  const CodeLoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<CodeLoginPage> createState() => _CodeLoginPageState();
}

class _CodeLoginPageState extends State<CodeLoginPage> {
  final TextEditingController _controller = TextEditingController();
  bool canTap = true;

  void codeLogin(BuildContext context) async {
    try {
      setState(() => canTap = false);
      final authService = AuthService();
      await authService.signInCode(_controller.text);
    }
    
    catch (e) {
      setState(() => canTap = true);
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: !canTap 
        ? CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _logo()),
            Expanded(child: _contents()),
            Expanded(child: _anonLogin(context)),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 64.0,
          child: Container(
            // margin: const EdgeInsets.symmetric(horizontal: 128.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isDarkMode
                ? const AssetImage('assets/logo/logo_white.png')
                : const AssetImage('assets/logo/logo_black.png'),
              )
            ),
          ),
        ),
      ],
    );
  }

  Widget _contents() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Still interested in keeping the chat as dry as me?:(",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inverseSurface,
            fontWeight: FontWeight.w300,
          ),
        ),

        const SizedBox(height: 25),

        MyTextField(
          hintText: "Code",
          obscureText: false,
          controller: _controller,
        ),

        const SizedBox(height: 25),

        Row(
          children: [
            Expanded(flex: 2, child: Container()),
            Expanded(
              flex: 3,
              child: MyButton(
                text: "Hop in",
                onTap: () => codeLogin(context),
              ),
            ),
            Expanded(flex: 2, child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _anonLogin(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Forgot code? Share a new",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            " memento..",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}