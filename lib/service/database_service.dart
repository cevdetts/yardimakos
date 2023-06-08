import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future<void> savingUserData(
      String fullName, String email, String password) async {
    await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "password": password,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  Future<QuerySnapshot> gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Stream<DocumentSnapshot> getUserGroups() {
    return userCollection.doc(uid).snapshots();
  }

  Future<void> createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference
        .collection("groups")
        .doc(groupDocumentReference.id)
        .set({
      "groupName": groupName,
      "groupId": groupDocumentReference.id,
    });
  }

  Stream<QuerySnapshot> getChats(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future<String> getGroupAdmin(String groupId) async {
    DocumentSnapshot groupSnapshot = await groupCollection.doc(groupId).get();
    return groupSnapshot['admin'];
  }

  Stream<DocumentSnapshot> getGroupMembers(String groupId) {
    return groupCollection.doc(groupId).snapshots();
  }

  Future<QuerySnapshot> searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  Future<bool> isUserJoined(String groupId, String groupName) async {
    DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
    Map<String, dynamic>? userData = userSnapshot.data() != null
        ? Map<String, dynamic>.from(userSnapshot.data() as Map<String, dynamic>)
        : null;

    if (userData != null && userData.containsKey('groups')) {
      Map<dynamic, dynamic>? groups = userData['groups'] != null
          ? Map<dynamic, dynamic>.from(
              userData['groups'] as Map<dynamic, dynamic>)
          : null;
      if (groups != null && groups.containsKey(groupId)) {
        return true;
      }
    }
    return false;
  }

  Future<void> toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot userSnapshot = await userDocumentReference.get();
    dynamic userData = userSnapshot.data();
    Map<String, dynamic>? groups;
    if (userData != null) {
      if (userData is Map<String, dynamic>) {
        groups = userData['groups'];
      }
    }

    if (groups != null && groups.containsKey(groupId)) {
      await userDocumentReference.collection("groups").doc(groupId).delete();
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"]),
      });
    } else {
      await userDocumentReference.collection("groups").doc(groupId).set({
        "groupName": groupName,
        "groupId": groupId,
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      });
    }
  }

  Future<void> sendMessage(
      String groupId, Map<String, dynamic> chatMessageData) async {
    await groupCollection
        .doc(groupId)
        .collection("messages")
        .add(chatMessageData);
    await groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
