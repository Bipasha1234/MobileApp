import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Components/button.dart';
import '../Components/textfield.dart';
import '../Services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()?onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final emailController =TextEditingController();
  final passwordController=TextEditingController();
  final confirmPasswordController=TextEditingController();

  // sign up user
  void signUp() async{
    if (passwordController.text!=confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("password do not match"),
          ),
      );
    return;
  }
    //get auth service
    final authService=Provider.of<AuthService>(context,listen:false);
 try{
   await authService.signUpWithEmailandPassword(emailController.text, passwordController.text);
 }catch(e){
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),
   ),
   );
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
                  const SizedBox(height: 50),
                  //logo
                  Icon(
                    Icons.app_registration,
                    size: 90,
                    color: Colors.grey[800],
                  ),
                  const SizedBox(height: 5),
                  //register account
                  Text("Register your account now!",
                    style: TextStyle(
                      fontSize: 20,fontWeight: FontWeight.bold,
                    ),

                  ),
                  const SizedBox(height: 30),
                  //email textfield
                  MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                  //password textfield
                  const SizedBox(height: 20),
                  MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                  //confirm password field
                  const SizedBox(height: 20),
                  MyTextField(controller: confirmPasswordController, hintText: 'confirmPassword', obscureText: true),
                  //sign Up btn
                  const SizedBox(height: 20),
                  MyButton(onTap:signUp, text: "Sign Up"),
                  const SizedBox(height: 5),
                  //not a mem, register now
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already registered?'),
                      const SizedBox(width: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login Now',
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
