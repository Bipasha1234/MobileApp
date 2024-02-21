import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_ui/Components/my_text_field.dart';
import 'package:insta_ui/Services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {

  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({super.key,required this.receiverUserEmail,required this.receiverUserID,});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController=TextEditingController();
  final ChatService _chatService =ChatService();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void sendMessage()async{
    //only send message if there is something to send
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserID, _messageController.text);
      //clear the text controller after sending the messages
      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(   backgroundColor: Color(0xFF075E54), title: Text(widget.receiverUserEmail)),
      backgroundColor: Color(0xFFE5F5F3),
      body:Column(
        children:[
          //messages
          Expanded(child: _buildMessageList(),
          ),
          //user input
          _buildMessageInput(),
          const SizedBox(height: 25,),
        ],
      ),
    );
  }
  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loaaading...');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
//build message item
Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic>data=document.data() as Map<String,dynamic>;

    //align the msg to right if sender is current user, else to left
    bool isMe = data['senderId'] == _firebaseAuth.currentUser!.uid;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.green.shade300 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['senderEmail'],
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),
            ),
            SizedBox(height: 5),
            Text(data['message'],style: TextStyle(fontSize: 17,),),
          ],
        ),
      ),
    );
}
//build msg input
Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textfield
          Expanded(child: MyTextField(
            controller: _messageController,
            hintText: 'Enter message',
            obscureText: false,
          ),
          ),
          //send btn
          IconButton(onPressed: sendMessage, icon: const Icon(Icons.send,size: 40, color: Colors.green,
            ))
        ],
      ),
    );
}
}

