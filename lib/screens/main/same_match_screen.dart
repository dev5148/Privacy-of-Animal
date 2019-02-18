import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:privacy_of_animal/bloc_helpers/bloc_event_state_builder.dart';
import 'package:privacy_of_animal/logics/current_user.dart';
import 'package:privacy_of_animal/logics/firebase_api.dart';
import 'package:privacy_of_animal/logics/friend_request/friend_request.dart';
import 'package:privacy_of_animal/logics/same_match/same_match.dart';
import 'package:privacy_of_animal/resources/resources.dart';
import 'package:privacy_of_animal/screens/main/other_profile_screen.dart';
import 'package:privacy_of_animal/utils/service_locator.dart';

class SameMatchScreen extends StatefulWidget {
  @override
  _SameMatchScreenState createState() => _SameMatchScreenState();
}

class _SameMatchScreenState extends State<SameMatchScreen> {

  final SameMatchBloc sameMatchBloc = sl.get<SameMatchBloc>();

  Widget _loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20.0),
          Text(
            '관심사가 비슷한 상대를 찾고 있습니다...',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15.0
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: primaryBlue,
        title: Text(
          '관심사 매칭',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => sameMatchBloc.emitEvent(SameMatchEventFindUser()),
          )
        ],
      ),
      body: BlocBuilder(
        bloc: sameMatchBloc,
        builder: (context, SameMatchState state){
          if(state.isLoading){
            return _loadingWidget();
          }
          if(state.isFindSucceeded) {
            if(state.sameMatchModel.tagTitle==null) {
              return Center(child: Text('아직까지 맞는 상대가 없습니다.'));
            }
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil.height/20),
                    child: Text(
                      '맞는 상대를 찾았습니다!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height/20),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: ScreenUtil.width/1.95,
                        percent: state.sameMatchModel.confidence,
                        lineWidth: 10.0,
                        progressColor: primaryBeige,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(state.sameMatchModel.profileImage),
                        radius: ScreenUtil.width/4.2,
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '${state.sameMatchModel.nickName}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '#${state.sameMatchModel.tagTitle} '
                    '#${state.sameMatchModel.tagDetail}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '${state.sameMatchModel.animalName} 얼굴형 / '
                    '${state.sameMatchModel.emotion} / '
                    '${state.sameMatchModel.age}살 / ${state.sameMatchModel.gender}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  RaisedButton(
                    color: Color(0xFFff647f),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    child: Text(
                      '★ 프로필 보기',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    elevation: 5.0,
                    onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => OtherProfileScreen(user:state.sameMatchModel.userInfo)
                      ));
                    }),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: sl.get<FirebaseAPI>().getFirestore()
                      .collection(firestoreUsersCollection)
                      .document(state.sameMatchModel.userInfo.documentID)
                      .collection(firestoreFriendsSubCollection)
                      .where(uidCol, isEqualTo: sl.get<CurrentUser>().uid)
                      .where(firestoreFriendsField, isEqualTo: false).snapshots(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData && snapshot.connectionState!=ConnectionState.waiting){
                        return RaisedButton(
                          color: primaryBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            '친구 신청하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          elevation: 5.0,
                          onPressed: () => sl.get<FriendRequestBloc>()
                            .emitEvent(FriendRequestEventSendRequest(
                              uid: state.sameMatchModel.userInfo.documentID)),
                        );
                      }
                      return Container();
                    }
                  )
                ],
              ),
            );
          }
          return Container();
        }
      ),
    );
  }
}