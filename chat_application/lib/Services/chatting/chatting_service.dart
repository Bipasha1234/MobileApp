import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/messages.dart';

class ChatService extends ChangeNotifier{
  //getting the  instance of  auth and firestore
  final FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;

  //sendting the  msg
Future<void> sendMessage(String receiverId,String message)async{
  //geting the  current user info

  final String currentUserId=_firebaseAuth.currentUser!.uid;
  final String currentUserEmail=_firebaseAuth.currentUser!.email.toString();
  final Timestamp timestamp=Timestamp.now();
  //creatinge a new msg
  Message newMessage=Message(
    senderId: currentUserId,
    senderEmail: currentUserEmail,
    receiverId: receiverId,
    timestamp: timestamp,
    message: message,
  );

  List<String> ids=[currentUserId,receiverId];
  ids.sort();
  String chatRoomId=ids.join(
    "_"
  ); //combineing the ids into a single string to use a chatroomID

  //add new msg to database
  await _firestore
  .collection('chat_rooms')
  .doc(chatRoomId)
  .collection('messages')
  .add(newMessage.toMap());
}
//get the  msg
Stream<QuerySnapshot>getMessages(String userId, String otherUserId){
  //constructing chat room id from user ids(sorted to ensure it matched the id used when sending messages.
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