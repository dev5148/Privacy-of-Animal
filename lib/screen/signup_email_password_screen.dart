import 'package:flutter/material.dart';
import 'package:privacy_of_animal/logics/authentication/authentication.dart';
import 'package:privacy_of_animal/resources/colors.dart';
import 'package:privacy_of_animal/widgets/arc_background.dart';
import 'package:privacy_of_animal/widgets/signup_email_password_form.dart';

class SignUpEmailPasswordScreen extends StatefulWidget {
  @override
  _SignUpEmailPasswordScreenState createState() => _SignUpEmailPasswordScreenState();
}

class _SignUpEmailPasswordScreenState extends State<SignUpEmailPasswordScreen> {

  final AuthenticationBloc bloc = AuthenticationBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ArcBackground(
                backgroundColor: signUpBackgroundColor,
                dashColor: signUpBackgroundColor,
                title: '회원가입',
              ),   
              SignUpEmailPasswordForm()
            ]
          ),
        ),
      )
    );
  }
}