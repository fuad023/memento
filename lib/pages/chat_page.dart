import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memento/components/my_app_bar.dart';
import 'package:memento/services/chat/chat_service.dart';
import 'package:memento/services/auth/auth_service.dart';
import 'package:memento/components/chat_bubble.dart';
import 'package:memento/components/my_textfield.dart';

class ChatPage extends StatefulWidget {
  final Map<String, String> hostMap;
  final Map<String, String> anonMap;
  final Map<String, String> senderMap;
  final Map<String, String> receiverMap;

  const ChatPage({
    super.key,
    required this.hostMap,
    required this.anonMap,
    required this.senderMap,
    required this.receiverMap,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // add listener to focus node
    // myFocusNode.addListener(() {
    //   if (myFocusNode.hasFocus) {
    //     print("TextField has focus"); // ignore: avoid_print

    //     // cause a delay so that the keyboard has time to show up
    //     // then the amount of remaining space will be calculated,
    //     // then scroll down
    //     Future.delayed(const Duration(milliseconds: 500), () {
    //       scrollDown();
    //     });
    //   } else {
    //     print("TextField has lost focus"); // ignore: avoid_print
    //   }
    // });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    String message = _messageController.text;
    _messageController.clear();
    if (message.isNotEmpty && message.trim().isNotEmpty) {
      
      await _chatService.sendMessage(
        widget.hostMap, 
        widget.anonMap, 
        widget.senderMap, 
        widget.receiverMap, 
        message,
      );
    }
    // scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: MyAppBar(
        title: widget.receiverMap['email']!.split('@')[0],
        actions: const []
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  // void scrollDown() {
  //   _scrollController.animateTo(
  //     _scrollController.position.minScrollExtent,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.hostMap, widget.anonMap),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading message list.."));
        }

        ChatService().sendReceipt(widget.hostMap, widget.anonMap, widget.senderMap['email']!);
        // return list view
        return ListView(
          reverse: true,
          controller: _scrollController,
          children:
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderEmail'] == _authService.getCurrentUser()!.email;

    // align message to the right if sender is the current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,  
      child: ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
        messageId: doc.id,
      ),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "share..",
              obscureText: false,
              focusNode: myFocusNode,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
      
          // send button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              color: Colors.white,
              iconSize: 16.0,
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_forward_ios_rounded,
              ),
            ),
          )
        ],
      ),
    );
  }
}