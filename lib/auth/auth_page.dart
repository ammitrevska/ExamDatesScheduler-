import 'package:flutter/material.dart';
import 'package:lab3/pages/login_page.dart';
import 'package:lab3/pages/register_page.dart';

class AuthPage extends StatefulWidget{
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>{

  //initially show login page
  bool showLogInPage = true;

  void toggleScreens() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if(showLogInPage){
      return LoginPage(showRegisterPage: toggleScreens);
    }
    else{
      return RegisterPage(showLogInPage: toggleScreens);
    }
  }
}