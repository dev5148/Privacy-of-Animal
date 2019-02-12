import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:privacy_of_animal/logics/current_user.dart';
import 'package:privacy_of_animal/logics/firebase_api.dart';
import 'package:privacy_of_animal/logics/random_chat/random_chat.dart';
import 'package:privacy_of_animal/resources/colors.dart';
import 'package:privacy_of_animal/resources/strings.dart';
import 'package:privacy_of_animal/utils/service_locator.dart';
import 'package:privacy_of_animal/utils/stream_navigator.dart';
import 'package:privacy_of_animal/widgets/progress_indicator.dart';

class RandomLoadingScreen extends StatefulWidget {
  @override
  _RandomLoadingScreenState createState() => _RandomLoadingScreenState();
}

class _RandomLoadingScreenState extends State<RandomLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '?? ?? ?? ?...',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryBlue
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: sl.get<FirebaseAPI>().firestore.collection(firestoreRandomChatCollection)
          .where(firestoreRandom,isGreaterThan: Random().nextInt(pow(2,32))).orderBy(firestoreRandom).limit(1).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData && snapshot.data.documents.length!=0){
            String selectedUser = snapshot.data.documents[0].documentID;
            if(selectedUser.compareTo(sl.get<CurrentUser>().uid)!=0){
              sl.get<RandomChatBloc>().emitEvent(RandomChatEventMatchUsers(
                user: selectedUser
              ));
              StreamNavigator.pushReplacementNamed(context, routeRandomChat);
            }
          }
          return CustomProgressIndicator();
        },
      ),
    );
  }
}