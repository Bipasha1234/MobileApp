import 'package:flutter/material.dart';
import 'package:insta_ui/Components/button.dart';
import 'package:insta_ui/Components/textfield.dart';
import 'package:insta_ui/Services/auth/auth_service.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  final void Function()?onTap;
  const LoginScreen({super.key,required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//text controllers
final emailController =TextEditingController();
final passwordController=TextEditingController();

void signIn()async{
  //get the auth service
  final authService=Provider.of<AuthService>(context,listen:false);

  try{
    await authService.signInWithEmailandPassword
      (emailController.text, passwordController.text,
    );
  } catch(e){
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body:SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 90),
                //logo
                Icon(
                  Icons.login,
                  size: 80,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 5),
                //welcome back messages
                  Text("Welcome to Chatting app!",
                    style: TextStyle(
                      fontSize: 20,fontWeight: FontWeight.bold,
                    ),

                  ),
                const SizedBox(height: 30),
                //email textfield
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false),
                //password textfield
                const SizedBox(height: 30),
                MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                //sign in btn
                const SizedBox(height: 30),
                MyButton(onTap:signIn, text: "Sign In"),
                const SizedBox(height: 10),
                //not a mem, register now
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not registered?'),
                    const SizedBox(width: 4,),
                    GestureDetector(onTap: widget.onTap,
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );

  }
}