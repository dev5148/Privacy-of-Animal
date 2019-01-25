import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:privacy_of_animal/bloc_helpers/bloc_helpers.dart';
import 'package:privacy_of_animal/logics/authentication/authentication.dart';
import 'package:privacy_of_animal/resources/colors.dart';
import 'package:privacy_of_animal/resources/constants.dart';
import 'package:privacy_of_animal/widgets/arc_background.dart';
import 'package:privacy_of_animal/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
    void initState() {
      super.initState();
      SystemChrome.setEnabledSystemUIOverlays([]);
    }

  @override
  Widget build(BuildContext context) {

    final AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ArcBackground(
                backgroundColor: loginBackgroundColor,
                dashColor: loginBackgroundColor,
                title: '로그인',
              ),
              SizedBox(height: ScreenUtil.height/10),    
              LoginForm(),
              BlocEventStateBuilder(
                bloc: bloc,
                builder: (context, AuthenticationState state){
                  return state.isAuthenticating ? CircularProgressIndicator() : Container();
                },
              )     
            ]
          ),
        ),
      ),
    );
  }
}