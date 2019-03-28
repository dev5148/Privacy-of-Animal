import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:privacy_of_animal/bloc_helpers/bloc_event_state_builder.dart';
import 'package:privacy_of_animal/logics/current_user.dart';
import 'package:privacy_of_animal/logics/firebase_api.dart';
import 'package:privacy_of_animal/logics/friend_request/friend_request.dart';
import 'package:privacy_of_animal/models/user_model.dart';
import 'package:privacy_of_animal/resources/resources.dart';
import 'package:privacy_of_animal/screens/sub/other_profile_sub.dart';
import 'package:privacy_of_animal/utils/profile_hero.dart';
import 'package:privacy_of_animal/utils/service_locator.dart';
import 'package:privacy_of_animal/utils/stream_snackbar.dart';
import 'package:privacy_of_animal/widgets/progress_indicator.dart';
import 'package:rxdart/rxdart.dart';

class OtherProfileScreen extends StatefulWidget {

  final UserModel user;

  OtherProfileScreen({@required this.user});  

  @override
  _OtherProfileScreenState createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {

  final FriendRequestBloc friendRequestBloc = sl.get<FriendRequestBloc>();

  Stream<bool> _getRequestStream() {
    Stream<QuerySnapshot> stream1 = sl.get<FirebaseAPI>().getFirestore().collection(firestoreUsersCollection)
      .document(widget.user.uid).collection(firestoreFriendsSubCollection)
      .where(uidCol,isEqualTo:sl.get<CurrentUser>().uid)
      .where(firestoreFriendsField,isEqualTo: false).snapshots();
    Stream<QuerySnapshot> stream2 = sl.get<FirebaseAPI>().getFirestore().collection(firestoreUsersCollection)
      .document(sl.get<CurrentUser>().uid).collection(firestoreFriendsSubCollection)
      .where(uidCol,isEqualTo:widget.user.uid)
      .where(firestoreFriendsField,isEqualTo: false).snapshots();
    return Observable.combineLatest2(stream1, stream2, (s1,s2){
      return (s1.documents.isNotEmpty || s2.documents.isNotEmpty) ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로필',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryBlue
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: ScreenUtil.width/20,right: ScreenUtil.width/20,bottom: ScreenUtil.height/20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil.height/20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '가상프로필',
                          style: primaryTextStyle,
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Row(
                            children: <Widget>[
                              Text(
                                '닮은 유명인 보기',
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Icon(Icons.search)
                            ],
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (context) => 
                              webViewImage(widget.user.fakeProfileModel.celebrity)
                          )),
                        )
                      ],
                    )
                  ),
                  SizedBox(height: 10.0),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    elevation: 5.0,
                    color: primaryGreen,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0,top: 10.0,bottom: 10.0),
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  CircularPercentIndicator(
                                    radius: ScreenUtil.width/2.8,
                                    percent: widget.user.fakeProfileModel.animalConfidence,
                                    lineWidth: 10.0,
                                    progressColor: primaryBeige,
                                  ),
                                  Hero(
                                    child: GestureDetector(
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage(widget.user.fakeProfileModel.animalImage),
                                        radius: ScreenUtil.width/6.2,
                                      ),
                                      onTap: () => profileHeroAnimation(
                                        context: context,
                                        image: widget.user.fakeProfileModel.animalImage
                                      ),
                                    ),
                                    tag: widget.user.fakeProfileModel.animalImage,
                                  )
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                widget.user.fakeProfileModel.nickName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              OtherFakeProfileForm(title: '추정동물',detail: widget.user.fakeProfileModel.animalName),
                              OtherFakeProfileForm(title: '추정성별',detail: widget.user.fakeProfileModel.gender),
                              OtherFakeProfileForm(title: '추정나이',detail: widget.user.fakeProfileModel.age),
                              OtherFakeProfileForm(title: '추정기분',detail: widget.user.fakeProfileModel.emotion),
                              OtherFakeProfileForm(title: '유명인   ',detail: widget.user.fakeProfileModel.celebrity)
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
            Container(
              color: Colors.grey.withOpacity(0.2),
              width: double.infinity,
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil.width/20,vertical: ScreenUtil.height/20),
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: sl.get<FirebaseAPI>().getFirestore().collection(firestoreUsersCollection)
                  .document(widget.user.uid).collection(firestoreFriendsSubCollection)
                  .where(uidCol,isEqualTo:sl.get<CurrentUser>().uid)
                  .where(firestoreFriendsField,isEqualTo: true).snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData && snapshot.data.documents.length!=0){
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            '실제프로필',
                            style: primaryTextStyle,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        OtherProfileRealForm(title: '이름',detail: widget.user.realProfileModel.name),
                        OtherProfileRealForm(title: '성별',detail: widget.user.realProfileModel.gender),
                        OtherProfileRealForm(title: '나이',detail: widget.user.realProfileModel.age),
                        OtherProfileRealForm(title: '직업',detail: widget.user.realProfileModel.job)
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.lock),
                            SizedBox(width: 10.0),
                            Text(
                              '실제 프로필은 친구가 될시 공개됩니다.',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ]
                        ),
                        SizedBox(height: 10.0),
                        StreamBuilder<bool>(
                          stream: _getRequestStream(),
                          builder: (context, snapshot){
                            if(snapshot.hasData && snapshot.data){
                              return Text(
                                '친구신청 승인 대기중입니다.',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              );
                            }
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return CustomProgressIndicator();
                            }
                            return GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: primaryBlue,
                                  border: Border.all(color: primaryBlue),
                                  borderRadius: BorderRadius.circular(3.0)
                                ),
                                child: Text(
                                  '친구신청 하기',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              onTap: () => friendRequestBloc
                                .emitEvent(FriendRequestEventSendRequest(uid: widget.user.uid)),
                            );
                          }
                        )
                      ]
                    );
                  }
                },
              )
            ),
            Container(
              color: Colors.grey.withOpacity(0.2),
              width: double.infinity,
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil.width/20,vertical: ScreenUtil.height/20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      '관심사 태그',
                      style: primaryTextStyle,
                    )
                  ),
                  SizedBox(height: 20.0),
                  OtherProfileTagPart(user: widget.user)
                ],
              )
            ),
            BlocBuilder(
              bloc: friendRequestBloc,
              builder: (context, FriendRequestState state){
                if(state.isSucceeded){
                  streamSnackbar(context, '친구신청에 성공하였습니다.');
                  friendRequestBloc.emitEvent(FriendRequestEventStateClear());
                } else if(state.isFailed){
                  streamSnackbar(context, '친구신청에 실패하였습니다.');
                  friendRequestBloc.emitEvent(FriendRequestEventStateClear());
                }
                return Container();
              },
            )
          ],
        )
      )
    );  
  }
}