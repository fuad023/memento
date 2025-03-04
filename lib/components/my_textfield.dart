import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FloatingLabelBehavior floatingLabelBehavior;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        minLines: 1,
        maxLines: 3,
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0.0,
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(16.0),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          // hintText: hintText,
          // hintStyle: TextStyle(
          //   color: Theme.of(context).colorScheme.primary,
          //   fontWeight: FontWeight.w300,
          // ),
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(hintText),
          ),
          floatingLabelBehavior: floatingLabelBehavior,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w300,
          ),
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            // fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}