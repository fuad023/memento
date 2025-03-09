import 'package:flutter/material.dart';
import 'package:memento/components/my_app_bar.dart';
import 'package:memento/components/my_drawer.dart';
import 'package:memento/components/user_tile.dart';
import 'package:memento/pages/chat_page.dart';

import 'package:memento/services/auth/auth_service.dart';
import 'package:memento/services/chat/chat_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:memento/themes/theme_provider.dart';

class HomePage extends StatefulWidget {
  final String hostID;

  const HomePage({
    super.key,
    required this.hostID,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  late final Map<String, String> hostMap;
  bool hostFound = false;

  void setHostMap(String uid) async {
    hostMap = (await _chatService.getHostMap(uid));
    if (!mounted) return;
    setState(() {
      hostFound = true;
    });
  }

  @override
  void initState() {
    super.initState();
    setHostMap(widget.hostID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MyAppBar(
        title: 'Home',
        actions: [
          CupertinoSwitch(
            thumbColor: Theme.of(context).colorScheme.primary,
            trackColor: Theme.of(context).colorScheme.secondary,
            activeColor: Theme.of(context).colorScheme.secondary,
            onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: hostFound
      ? _buildUserList(context)
      : Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return _authService.getCurrentUser()!.email != hostMap['email']
    ? _chatWithHost()
    : StreamBuilder(
      stream: _chatService.getAnonsStream(hostMap),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error building user list: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading anons.."));
        }

        // return list view
        return snapshot.data!.isEmpty
        ? Center(
          child: Text(
          'why so lonely:(',
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
    );
  }

  Widget _chatWithHost() {
    Map<String, String> anonMap = {
      'email': _authService.getCurrentUser()!.email!,
      'uid'  : _authService.getCurrentUser()!.uid,
    };
    return StreamBuilder(
      stream: _chatService.getUnreadMessageCountStream(hostMap, anonMap, _authService.getCurrentUser()!.email!),
      builder: (context, snapshot) {
        /* 
         * data can be null, which causes hasError to be true
         * but null means anon have not sent the very first message
         * which would create necessary fields to have any value other than null
         */
        // if (snapshot.hasError) {
        //   return Center(child: Text(snapshot.error.toString()));
        // }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading unread message count.."));
        }

        // return list view
        return UserTile(
          text: hostMap['email']!.split('@')[0],
          unreadMessase: snapshot.data?['unreadMessasageCount'] ?? 0,
          timestamp: snapshot.data?['recent_act'],
          onTap: () {
            // tapped on a user -> go to chat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  hostMap: hostMap,
                  anonMap: anonMap,
                  senderMap: anonMap,
                  receiverMap: hostMap,
                ),
              ),
            );
          },
        );
      }
    );
    
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    Map<String, String>  receiverMap = {
      'email': userData["email"],
      'uid'  : userData['uid'],
    };
    return StreamBuilder(
      stream: _chatService.getUnreadMessageCountStream(hostMap, receiverMap, _authService.getCurrentUser()!.email!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error building messages: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading unread message count.."));
        }

        // return list view
        return UserTile(
          text: userData['email'].toString().split('@')[0],
          unreadMessase: snapshot.data!['unreadMessasageCount'],
          timestamp: snapshot.data!['recent_act'],
          onTap: () {
            // tapped on a user -> go to chat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  hostMap    : hostMap,
                  anonMap    : receiverMap,
                  senderMap  : hostMap,
                  receiverMap: receiverMap,
                ),
              ),
            );
          },
        );
      }
    );
  }
}