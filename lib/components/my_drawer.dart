import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memento/services/auth/auth_service.dart';
import 'package:memento/pages/delete_anons_page.dart';
import 'package:memento/credential.dart';
import 'package:flutter/services.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isTerminating = false;
  final _auth = AuthService();
  final _firestore = FirebaseFirestore.instance;
  final String hostEmail = Credential.HOST_EMAIL_FUAD;
  final String password = Credential.PASSWORD;

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
                          _saveUid(),
                          // Text(
                          //   _auth.getCurrentUser()!.email!,
                          //   style: TextStyle(color: Theme.of(context).colorScheme.surface),
                          // ),
                          // Theme(
                          //   data: Theme.of(context).copyWith(
                          //     textSelectionTheme: TextSelectionThemeData(
                          //       selectionColor: Theme.of(context).colorScheme.surface,
                          //       selectionHandleColor: Theme.of(context).colorScheme.tertiary,
                          //     ),
                          //   ),
                          //   child: SelectableText(
                          //     _auth.getCurrentUser()!.uid,
                          //     style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // _listTile(context, "F U A D", Icons.person, hopIntoFuad),
                  ],
                ),
                Column(
                  children: [
                    if (_auth.getCurrentUser()!.email! != hostEmail) _listTile(context, 'T E R M I N A T E', Icons.delete_forever, terminate, caution: true),
                    if (_auth.getCurrentUser()!.email! == hostEmail) _listTile(context, 'D A N G E R', Icons.dangerous, () => goToDanger(context), caution: true),
                    _listTile(context, 'B O U N C E', Icons.logout, logout, bottomPadding: true),
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

  Widget _saveUid() {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: _auth.getCurrentUser()!.uid));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            showCloseIcon: true,
            closeIconColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            content: Text(
              "Copied to clipboard!",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          )
        );
      },
      child: Text(
        _auth.getCurrentUser()!.uid,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
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

  void hopIntoFuad() async {
    await _auth.signOut();
    try {
      String uid = '';
      try {
        DocumentSnapshot docSnap = await _firestore.collection('users').doc(hostEmail).get();
        if (docSnap.exists) {
          uid = docSnap.get('uid');
        }
      } catch (e) { throw Exception('Error retrieving fuad email: $e'); }
      await _auth.signInCode(uid);
    } catch (e) {

      await _auth.signUp(hostEmail, password, 0);
      await _firestore.collection('hosts').doc(hostEmail).set({
        'uid': _auth.getCurrentUser()!.email,
        }, SetOptions(merge: true)
      );

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

  void logout() {
    _auth.signOut();
  }

}