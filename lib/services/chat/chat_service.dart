import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memento/model/message.dart';
import 'package:memento/credential.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>> getHostMap(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('hosts')
        .where('uid', isEqualTo: uid)
        .get();

    var doc = querySnapshot.docs.first;
    return {
      'uid'  : doc['uid'],
      'email': doc.id,
    };
  }

  Stream<List<Map<String, dynamic>>> getAnonsStream(Map hostMap) {
    return _firestore
      .collection('hosts')
      .doc(hostMap['email'])
      .collection('anons')
      .orderBy('recent_act', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) =>
          {
            'email': doc.id,
            'uid': doc.data()['uid'],
            // 'timestamp': doc.data()['recent_act'],
          }).toList();
      });
  }

  // SEND MESSAGE
  Future<void> sendMessage(Map host, Map anon, Map sender, Map receiver, String message) async {
    DocumentReference docRef = _firestore.collection('hosts').doc(host['email']).collection('anons').doc(anon['email']);
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderEmail: sender['email'],
      receiverEmail: receiver['email'],
      message: message,
      timestamp: timestamp
    );

    try {
      // await docRef.collection('recent').doc(receiver['email']).set({ 
      //     'recent_act'  : FieldValue.serverTimestamp(),
      //     'unreadMessasageCount': FieldValue.increment(1)
      //   },
      //   SetOptions(merge: true)
      // );
      // await docRef.collection('recent').doc(sender['email']).set(
      //   { 'recent_act'  : FieldValue.serverTimestamp() }, SetOptions(merge: true));
      // add new message to database
      /* await */ docRef.collection('chat_room').add(newMessage.toMap());

      /* await */ docRef.set({
        'uid'         : anon['uid'],
        'recent_act'  : FieldValue.serverTimestamp(),
        'recent_actor': sender['email'],
        // 'message_count': messageCount,
        'unreadMsgCount_${receiver['email']}': FieldValue.increment(1),
      }, SetOptions(merge: true));

      QuerySnapshot querySnapshot = await docRef.collection('chat_room').get();
      /* await */docRef.set({
        'message_count': querySnapshot.size,
      }, SetOptions(merge: true));

    } catch (e) {
      throw Exception("Error sending message: $e");
    }
  }

  // GET MESSAGE
  Stream<QuerySnapshot> getMessages(Map host, Map anon) {
    DocumentReference docRef = _firestore.collection('hosts').doc(host['email']).collection('anons').doc(anon['email']);

    return docRef
        .collection('chat_room')
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // DELIVERY RECEIPT 
  Future<void> sendReceipt(Map host, Map anon, String curretUserEmail) async {
    DocumentReference docRef = _firestore.collection('hosts').doc(host['email']).collection('anons').doc(anon['email']);

    try {
      /* await */ docRef.set({
        'receipt_$curretUserEmail'       : FieldValue.serverTimestamp(),
        'unreadMsgCount_$curretUserEmail': 0,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Error receiving message: $e");
    }
  }

  Stream<Map<String, dynamic>> getUnreadMessageCountStream(Map host, Map anon, String curretUserEmail) {
    return _firestore.collection('hosts').doc(host['email']).collection('anons').doc(anon['email'])
      .snapshots()
      .map((snapshot) {
        Map<String, dynamic> data = {};
        if (snapshot.exists) {
          data = {
            'unreadMessasageCount': snapshot.data()!['unreadMsgCount_$curretUserEmail'],
            'recent_act' : snapshot.data()!['recent_act'],
          };
        }
        return data;
      });
  }

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore
      .collection('stats')
      .doc('user_list')
      .snapshots()
      .map((snapshot) {
        if (!snapshot.exists) return [];

        Map<String, dynamic> data = snapshot.data() ?? {};
        return data.entries
        .where((entry) => entry.value != Credential.HOST_EMAIL_FUAD)
        .map((entry) {
          return {
            'uid'  : entry.key,
            'email': entry.value,
          };
        }).toList();
      });
  }

}