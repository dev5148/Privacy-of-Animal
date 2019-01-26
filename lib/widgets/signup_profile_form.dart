import 'package:flutter/material.dart';
import 'package:privacy_of_animal/bloc_helpers/multiple_bloc_provider.dart';
import 'package:privacy_of_animal/logics/signup/signup.dart';
import 'package:privacy_of_animal/logics/validation/validation_bloc.dart';
import 'package:privacy_of_animal/resources/resources.dart';
import 'package:privacy_of_animal/widgets/focus_visible_maker.dart';
import 'package:privacy_of_animal/widgets/initial_button.dart';

class SignUpProfileForm extends StatefulWidget {
  @override
  _SignUpProfileFormState createState() => _SignUpProfileFormState();
}

class _SignUpProfileFormState extends State<SignUpProfileForm> {

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ageFocusNode = FocusNode();
  final FocusNode _jobFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();


  @override
    void dispose() {
      _nameController.dispose();
      _ageController.dispose();
      _jobController.dispose();
      _nameFocusNode.dispose();
      _ageFocusNode.dispose();
      _jobFocusNode.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {

    final ValidationBloc validationBloc = MultipleBlocProvider.of<ValidationBloc>(context);
    final SignUpBloc signUpBloc = MultipleBlocProvider.of<SignUpBloc>(context);

    return Container(
      height: ScreenUtil.height/1.8,
      width: ScreenUtil.width/1.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              '이름',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.0
              ),
            ),
          ),
          StreamBuilder<String>(
            stream: validationBloc.name,
            initialData: signUpEmptyNameError,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
              return EnsureVisibleWhenFocused(
                focusNode: _nameFocusNode,
                child: TextField(
                  decoration: InputDecoration(
                    errorText: snapshot.error,
                    hintText: signUpNameHint
                  ),
                  onChanged: validationBloc.onNameChanged,
                  keyboardType: TextInputType.text,
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil.height/25),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              '나이',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.0
              ),
            ),
          ),
          StreamBuilder<String>(
            stream: validationBloc.age,
            initialData: signUpEmptyAgeError,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
              return EnsureVisibleWhenFocused(
                focusNode: _ageFocusNode,
                child: TextField(
                  decoration: InputDecoration(
                    errorText: snapshot.error,
                    hintText: signUpAgeHint
                  ),
                  onChanged: validationBloc.onAgeChanged,
                  controller: _ageController,
                  focusNode: _ageFocusNode,
                  keyboardType: TextInputType.number,
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil.height/25),
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              '직업',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.0
              ),
            ),
          ),
          StreamBuilder<String>(
            stream: validationBloc.job,
            initialData: signUpEmptyAgeError,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
              return EnsureVisibleWhenFocused(
                focusNode: _jobFocusNode,
                child: TextField(
                  decoration: InputDecoration(
                    errorText: snapshot.error,
                    hintText: signUpJobHint
                  ),
                  onChanged: validationBloc.onJobChanged,
                  keyboardType: TextInputType.text,
                  controller: _jobController,
                  focusNode: _jobFocusNode,
                ),
              );
            },
          ),
          SizedBox(height: ScreenUtil.height/15),
          StreamBuilder<bool>(
            stream: validationBloc.signUpProfileValid,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              return InitialButton(
                text: '선택완료',
                color: introLoginButtonColor,
                callback: (snapshot.hasData && snapshot.data==true) ? 
                () {
                  signUpBloc.emitEvent(SignUpEventProfileComplete(
                    name: _nameController.text,
                    age: _ageController.text,
                    job: _jobController.text,
                    gender: 'm'
                  ));
                }
                : null,
              );
            },
          )
        ],
      ),
    );
  }
}