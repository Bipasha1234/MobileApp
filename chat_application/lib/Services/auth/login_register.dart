import 'package:flutter/material.dart';
import 'package:insta_ui/pages/login.dart';
import 'package:insta_ui/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially showing the login screen
  bool showLoginPage=true;

  //toggle betwn login and register page
  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginScreen(onTap: togglePages);
    }else{
      return RegisterPage(onTap: togglePages);
    }
  }
}
