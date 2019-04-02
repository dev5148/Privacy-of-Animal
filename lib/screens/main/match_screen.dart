import 'package:flutter/material.dart';
import 'package:privacy_of_animal/logics/current_user.dart';
import 'package:privacy_of_animal/logics/random_loading/random_loading.dart';
import 'package:privacy_of_animal/logics/same_match/same_match.dart';
import 'package:privacy_of_animal/models/tag_list_model.dart';
import 'package:privacy_of_animal/resources/colors.dart';
import 'package:privacy_of_animal/resources/constants.dart';
import 'package:privacy_of_animal/resources/strings.dart';
import 'package:privacy_of_animal/utils/service_locator.dart';
import 'package:flare_flutter/flare_actor.dart';


class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {

  final TagListModel tagListModel = sl.get<CurrentUser>().tagListModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '매칭하기',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: primaryBlue
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child:Container(
                  width: ScreenUtil.width*0.8,
                  child: Stack(
                    // mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Positioned(
                        left: ScreenUtil.width*0.3,
                        child: Container(
                          height: ScreenUtil.width*0.28,
                          child: FlareActor(
                            "assets/images/components/magnet.flr",
                            alignment:Alignment.center,
                            fit: BoxFit.fitHeight,
                            animation: 'Move',
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text("상대 추천"),)
                    ],
                  ),
                ),
              ),
              Card(
                child:Container(
                  width: ScreenUtil.width*0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil.width*0.28,
                        child: FlareActor(
                          "assets/images/components/magnet.flr",
                          alignment:Alignment.center,
                          fit: BoxFit.fitHeight,
                          animation: 'Move',
                        ),
                      ),
                      ListTile(
                        title: Text("상대 추천"),)
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: ScreenUtil.width*0.8,
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text("랜덤 추천")
                      ),
                      Expanded(
                        child: Container(
                          height: ScreenUtil.width*0.2,
                          // width: ScreenUtil.width*0.8,
                          child: FlareActor(
                            "assets/images/components/roulette dart.flr",
                            alignment: Alignment.center,
                            fit: BoxFit.fitHeight,
                            animation: 'rolling lr',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )

//        Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Image(
//              image: AssetImage('assets/images/components/match_random_circle.png'),
//              width: ScreenUtil.width * .8,
//              height: ScreenUtil.width * .8,
//            ),
//            SizedBox(
//              height: ScreenUtil.height * 0.001,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                FlatButton(
//                  color: primaryBeige,
//                  child: Text("상대 추천"),
//                  onPressed: () {
//                    sl.get<SameMatchBloc>().emitEvent(SameMatchEventFindUser());
//                    Navigator.pushNamed(context, routeSameMatch);
//                  },
//                  shape: RoundedRectangleBorder(side: BorderSide(color : Colors.orange[200], width : 1.3) ,borderRadius: BorderRadius.circular(10.0)),
//                ),
//                SizedBox(width: ScreenUtil.width *.09),
//                FlatButton(
//                  color: primaryBeige,
//                  child: Text("랜덤 매칭"),
//                  onPressed: () {
//                    sl.get<RandomLoadingBloc>().emitEvent(RandomLoadingEventMatchStart());
//                    Navigator.pushNamed(context, routeRandomLoading);
//                  },
//                  shape: RoundedRectangleBorder(side: BorderSide(color : Colors.orange[200], width : 1.3) ,borderRadius: BorderRadius.circular(10.0)),
//                )
//              ],
//            )
//          ],
//        )
//      body: Stack(
//        children: <Widget>[
//          Positioned(
//            top: -ScreenUtil.height/10,
//            left: -ScreenUtil.width/2,
//            child: GestureDetector(
//              child: Image(
//                image: AssetImage('assets/images/components/match_tag_circle.png'),
//                width: ScreenUtil.width*1.1,
//                height: ScreenUtil.width*1.1
//              ),
//              onTap: () {
//                sl.get<SameMatchBloc>().emitEvent(SameMatchEventFindUser());
//                Navigator.pushNamed(context, routeSameMatch);
//              },
//            ),
//          ),
//          TagTitleForm(
//            content: tagListModel.tagTitleList[0],
//            left: ScreenUtil.width/7,
//            top: ScreenUtil.height/15,
//          ),
//          TagTitleForm(
//            content: tagListModel.tagTitleList[1],
//            left: ScreenUtil.width/12,
//            top: ScreenUtil.height/8,
//          ),
//          TagTitleForm(
//            content: tagListModel.tagTitleList[2],
//            left: ScreenUtil.width/13,
//            top: ScreenUtil.height/5.5,
//          ),
//          TagTitleForm(
//            content: tagListModel.tagTitleList[3],
//            left: ScreenUtil.width/11,
//            top: ScreenUtil.height/4,
//          ),
//          TagTitleForm(
//            content: tagListModel.tagTitleList[4],
//            left: ScreenUtil.width/15,
//            top: ScreenUtil.height/3.2,
//          ),
//          Positioned(
//            left: ScreenUtil.width/3,
//            top: ScreenUtil.height/6,
//            child: ExplainWidget(
//              content: '관심사 일치\n대화상대 추천'
//            ),
//          ),
//          Positioned(
//            bottom: -ScreenUtil.height/7,
//            right: -ScreenUtil.width/2,
//            child: GestureDetector(
//              child: Image(
//                width: ScreenUtil.width*1.1,
//                height: ScreenUtil.width*1.1,
//                image: AssetImage('assets/images/components/match_random_circle.png'),
//              ),
//              onTap: () {
//                sl.get<RandomLoadingBloc>().emitEvent(RandomLoadingEventMatchStart());
//                Navigator.pushNamed(context, routeRandomLoading);
//              }
//            )
//          ),
//          Positioned(
//            right: ScreenUtil.width/4,
//            bottom: ScreenUtil.height/6,
//            child: ExplainWidget(
//              content: '완전 랜덤 매칭'
//            ),
//          ),
//        ],
//      )
    );
  }
}

class ExplainWidget extends StatelessWidget {

  final String content;

  ExplainWidget({@required this.content});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          content,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class TagTitleForm extends StatelessWidget {
  final String content;
  final double left;
  final double top;

  TagTitleForm({
    @required this.content,
    @required this.left,
    @required this.top
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: primaryGreen,
              width: 3.0
            ),
            color: Colors.white.withOpacity(0.2)
          ),
          child: Text(
            '# $content',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        onTap: () {
          sl.get<SameMatchBloc>().emitEvent(SameMatchEventFindUser());
          Navigator.pushNamed(context, routeSameMatch);
        }
      ),
    );
  }
}