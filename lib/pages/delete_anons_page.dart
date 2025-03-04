import 'package:flutter/material.dart';
import 'package:memento/services/auth/auth_service.dart';
import 'package:memento/services/chat/chat_service.dart';

class DeleteAnonsPage extends StatefulWidget {
  const DeleteAnonsPage({super.key});

  @override
  State<DeleteAnonsPage> createState() => _DeleteAnonsPageState();
}

class _DeleteAnonsPageState extends State<DeleteAnonsPage> {
  final AuthService auth = AuthService();
  bool wait = false;

  void delete(String uid) async {
    wait = true;
    setState(() {});
    wait = await auth.deleteAnons(uid);
    setState(() {});
  }

  void login(String uid) async {
    await auth.signOut();
    await auth.signInCode(uid);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: ChatService().getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading anons.."));
          }

          // return list view
          return wait 
          ? const Center(child: CircularProgressIndicator())
          : snapshot.data!.isEmpty
          ? Center(
            child: Text(
              'Anon unavailable!',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w300,
              ),
            )
          )
          : ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        }
      ),
    );
  }

  Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context) {
    return userTile(
      context: context,
      text: userData['email'],
      onTap: () => delete(userData['uid']),
      onLongPress: () => login(userData['uid']),
    );
  }

  Widget userTile({
    required BuildContext context,
    required String text,
    required void Function()? onTap,
    required void Function()? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 20.0),
            Text(text),
          ]
        ),
      ),
    );
  }
}