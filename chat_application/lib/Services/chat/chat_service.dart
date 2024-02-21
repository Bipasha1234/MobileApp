import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/message.dart';

class ChatService extends ChangeNotifier{
  //get instance of  auth and firestore
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;

  //send msg
Future<void> sendMessage(String receiverId,String message)async{
  //get current user info

  final String currentUserId=_firebaseAuth.currentUser!.uid;
  final String currentUserEmail=_firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp=Timestamp.now();
  //create a new msg
  Message newMessage=Message(
    senderId: currentUserId,
    senderEmail: currentUserEmail,
    receiverId: receiverId,
    timestamp: timestamp,
    message: message,
  );

  //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
  List<String> ids=[currentUserId,receiverId];
  ids.sort(); //sort the ids(this ensures the chat room id is always the same for any pair of people.
  String chatRoomId=ids.join(
    "_"
  ); //combine the ids into a single string to use a chatroomID

  //add new msg to database
  await _firestore
  .collection('chat_rooms')
  .doc(chatRoomId)
  .collection('messages')
  .add(newMessage.toMap());
}
//get msg
Stream<QuerySnapshot>getMessages(String userId, String otherUserId){
  //construct chat room id from user ids(sorted to ensure it matched the id used when sending messages.
  List<String> ids=[userId,otherUserId];
  ids.sort();
  String chatRoomId=ids.join("_");

  return _firestore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .orderBy('timestamp',descending: false)
      .snapshots();
}
}