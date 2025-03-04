import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memento/services/auth/auth_service.dart';
import 'package:memento/pages/settings_page.dart';
import 'package:memento/pages/delete_anons_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isTerminating = false;
  final _auth = AuthService();
  final _firestore = FirebaseFirestore.instance;

  void logout() {
    _auth.signOut();
  }

  void goToSettings(BuildContext context) {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void hopIntoFuad() async {
    await _auth.signOut();
    try {
      String uid = '';
      try {
        DocumentSnapshot docSnap = await _firestore.collection('users').doc('fuad@seele.com').get();
        if (docSnap.exists) {
          uid = docSnap.get('uid');
        }
      } catch (e) { throw Exception('Error retrieving fuad email: $e'); }
      await _auth.signInCode(uid);
    } catch (e) {
      await _auth.signUp('fuad@seele.com', '12345678', 0);
      throw Exception("Sign in error to host (fuad): $e");
    }
  }

  void terminate() async {
    setState(() => isTerminating = true);
    isTerminating = await _auth.terminateAnon();
    if (!mounted) return;
    setState(() {});
  }

  void goToDanger(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DeleteAnonsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _logo(),
                          // Text(
                          //   _auth.getCurrentUser()!.email!,
                          //   style: TextStyle(color: Theme.of(context).colorScheme.surface),
                          // ),
                          Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: TextSelectionThemeData(
                                selectionColor: Theme.of(context).colorScheme.surface,
                                selectionHandleColor: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            child: SelectableText(
                              _auth.getCurrentUser()!.uid,
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // _listTile(context, "S E T T I N G S", Icons.settings, () => goToSettings(context)),
                    _listTile(context, "F U A D", Icons.person, hopIntoFuad),
                  ],
                ),
                Column(
                  children: [
                    if (_auth.getCurrentUser()!.email! != 'fuad@seele.com') _listTile(context, 'T E R M I N A T E', Icons.delete_forever, terminate, caution: true),
                    _listTile(context, 'D A N G E R', Icons.dangerous, () => goToDanger(context), caution: true),
                    _listTile(context, 'L O G O U T', Icons.logout, logout, bottomPadding: true),
                  ],
                ),
              ],
            ),
            if (isTerminating) Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ],
        )
      ),
    );
  }

  Widget _logo() {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Expanded(flex: 2, child: Container()),
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo/logo_white.png'),
                )
              ),
            ),
          ),
          Expanded(flex: 2, child: Container()),
        ],
      ),
    );
  }

  Widget _listTile(
    BuildContext context,
    String title,
    IconData? icon,
    void Function()? onTap,
    { 
      bool bottomPadding = false,
      bool caution = false,
    }
  ) {
    return Padding(
      padding: bottomPadding ? const EdgeInsets.only(left: 25.0, bottom: 25.0) : const EdgeInsets.only(left: 25.0),
      child: ListTile(
        title: Text(title),
        leading: Icon(
          icon,
          color: caution
          ? Colors.red
          : Theme.of(context).colorScheme.primary,
        ),
        onTap: onTap,
      ),
    );
  }
}