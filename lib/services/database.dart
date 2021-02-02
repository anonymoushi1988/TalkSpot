import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  getUserByUsername(String username) async {
    try {
      return await firestore
          .collection("users")
          .where("name", isEqualTo: username)
          .get();
    } catch (e) {
      return e;
    }
  }

  getUserByUserEmail(String userEmail) async {
    try {
      return await firestore
          .collection("users")
          .where("email", isEqualTo: userEmail)
          .get();
    } catch (e) {
      print(e);
      return (e);
    }
  }

  uploadUserInfo(userMap, google) async {
    bool save = true;
    if (google) {
      var a = await firestore.collection("users").get();
      for (int i = 0; i < a.docs.length; i++) {
        if (a.docs[i]["email"] == userMap["email"]) {
          save = false;
          break;
        }
      }
    }
    if (save) {
      print("save");

      await firestore.collection("users").doc().set(userMap);
    }
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    firestore
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e);
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    firestore
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  getConversationMessages(String chatRoomId) async {
    return firestore
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return firestore
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
