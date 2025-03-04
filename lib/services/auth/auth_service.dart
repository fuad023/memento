import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signUpAnon() async {
    int id;
    DocumentReference docRef = _firestore.collection('stats').doc('user_base');

    try {
      await docRef.update({'count_created': FieldValue.increment(1)});
      DocumentSnapshot snapshot = await docRef.get();
      id = snapshot.get('count_created');
    } catch (e) {
      throw Exception("Error retrieving count_created: $e");
    }
    
    await signUp("user$id@seele.com", "12345678", id);
  }

  Future<void> signUp(String email, password, int id) async {
    try {
      // create user
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info in a separate doc
      _firestore.collection("users").doc(userCredential.user!.email).set({
          'id'     : id,
          'uid'    : userCredential.user!.uid,
          'email'  : userCredential.user!.email,
          'created': FieldValue.serverTimestamp(),
      });

      _firestore.collection('stats').doc('user_list').set(
        { userCredential.user!.uid : userCredential.user!.email },
        SetOptions(merge: true)
      );
    } on FirebaseAuthException catch (e) {
      throw Exception("Sign up error: ${e.code}");
    }
  }

  Future<void> signInCode(String code) async {
    String email;
    DocumentReference docRef = _firestore.collection('stats').doc('user_list');

    try {
      DocumentSnapshot snapshot = await docRef.get();
      email = snapshot.get(code);
    } on FirebaseAuthException catch (e) {
      throw Exception("Error retrieving user email: ${e.code}");
    }
    
    await signIn(email, '12345678');
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw Exception("Sign in error: ${e.code}");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> deleteAnons(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      String code = uid;
      try { // logged in
        code = getCurrentUser()!.uid;
      } catch (e) { // NOT logged in
        await signInCode(uid);
      }
      bool isCurrent = code == uid;
      if (!isCurrent) { // logged in
        await signOut();
        await signInCode(uid);
      }

      String id = getCurrentUser()!.uid;
      String email = getCurrentUser()!.email!;

      /* await */ firestore.collection('users').doc(email).delete();
      /* await */ firestore.collection('stats').doc('user_list').update({ id: FieldValue.delete() });

      // delete rocords from all hosts
      QuerySnapshot hostsSnapshot = await firestore.collection('hosts').get();
      for (DocumentSnapshot hostDoc in hostsSnapshot.docs) {
        CollectionReference anonsCollection = firestore.collection('hosts').doc(hostDoc.id).collection('anons');
        DocumentSnapshot anonDoc = await anonsCollection.doc(email).get();
        if (anonDoc.exists) /* await */ anonsCollection.doc(email).delete();
      }

      /* await */ firestore.collection('users').count().get().then((snapshot) {
        // 0 - even fuad host does not exist
        // 1 - only fuad host exists
        if (snapshot.count! < 2) {
          firestore.collection('stats').doc('user_base').set({'count_created': 0});
        }
      });

      await getCurrentUser()!.delete();

      if (!isCurrent) signInCode(code);
      return false;
    } catch (e) {
      throw Exception("Error deleting anon: $e");
      // return false;
    }
  }

  Future<bool> terminateAnon() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      String uid = getCurrentUser()!.uid;
      String email = getCurrentUser()!.email!;

      /* await */ firestore.collection('users').doc(email).delete();
      /* await */ firestore.collection('stats').doc('user_list').update({ uid: FieldValue.delete() });

      // delete rocords from all hosts
      QuerySnapshot hostsSnapshot = await firestore.collection('hosts').get();
      for (DocumentSnapshot hostDoc in hostsSnapshot.docs) {
        CollectionReference anonsCollection = firestore.collection('hosts').doc(hostDoc.id).collection('anons');
        DocumentSnapshot anonDoc = await anonsCollection.doc(email).get();
        if (anonDoc.exists) /* await */ anonsCollection.doc(email).delete();
      }

      /* await */ firestore.collection('users').count().get().then((snapshot) {
        // 0 - even fuad host does not exist
        // 1 - only fuad host exists
        if (snapshot.count! < 2) {
          firestore.collection('stats').doc('user_base').set({'count_created': 0}, SetOptions(merge: true));
        }
      }); firestore.collection('stats').doc('user_base').set({'count_terminated': FieldValue.increment(1)}, SetOptions(merge: true));

      AuthCredential credential = EmailAuthProvider.credential(email: email, password: '12345678');
      await getCurrentUser()!.reauthenticateWithCredential(credential);
      await getCurrentUser()!.delete();
      
      return false;
    } catch (e) {
      throw Exception("Error terminating anon: $e");
      // return false;
    }
  }
}