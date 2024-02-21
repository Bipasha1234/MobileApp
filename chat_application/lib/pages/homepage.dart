import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_ui/Services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'chatting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF075E54), // Green color similar to WhatsApp
        title: Text('Home Page',),

        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            iconSize: 35,
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

            if (_auth.currentUser!.email != data['email']) {
              return ListTile(
                leading: CircleAvatar(
                  // You can replace this with user's image if available
                  child: Text(data['email'][0]),
                ),
                title: Text(
                  data['email'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverUserEmail: data['email'],
                        receiverUserID: data['uid'],
                      ),
                    ),
                  );
                },
              );
            } else {
              return SizedBox.shrink(); // Empty SizedBox
            }
          },
          separatorBuilder: (context, index) => Divider(), // Add divider between items
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
