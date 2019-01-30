
import 'package:flutter/material.dart';
import 'package:privacy_of_animal/bloc_helpers/bloc_helpers.dart';
import 'package:privacy_of_animal/logics/tag/tag.dart';
import 'package:privacy_of_animal/logics/validation/validation_bloc.dart';
import 'package:privacy_of_animal/resources/resources.dart';
import 'package:privacy_of_animal/widgets/initial_button.dart';

class TagScreen extends StatefulWidget {
  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {


  @override
  Widget build(BuildContext context) {

    final TagBloc _tagBloc = TagBloc();
    final ValidationBloc _validationBloc = ValidationBloc();
    List<bool> isActivateList = List.generate(tags.length, (i) => false);

    return Scaffold(
      body: Column(
        children:<Widget>[
          Container(
            padding: const EdgeInsets.only(top: 40.0,left: 50.0,right: 50.0),
            child: Text(
              '관심있는 태그 5개만 선택해주세요!',
              style: TextStyle(
                color: primaryPink,
                fontWeight: FontWeight.bold,
                fontSize: 18.0
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: tags.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(20.0),
            itemBuilder: (BuildContext context, int index){
              return  BlocBuilder(
                bloc: _tagBloc,
                builder: (context, TagState state){
                  if(state.isTagActivated && state.tagIndex==index){
                    isActivateList[index] = true;
                  }
                  else if(state.isTagDeactivated && state.tagIndex==index){
                    isActivateList[index] = false;
                  }
                  return GestureDetector(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image(
                          image: tags[index].image,
                          width: ScreenUtil.width/3.5,
                          height: ScreenUtil.width/3.5
                        ),
                        Container(
                          width: ScreenUtil.width/3.5-10.0,
                          height: ScreenUtil.width/3.5-10.0,
                          decoration: BoxDecoration(
                            color: isActivateList[index] ? Colors.black.withOpacity(0.5) : Colors.transparent,
                            shape: BoxShape.circle
                          ),
                        ),
                        Positioned(
                          bottom: 20.0,
                          child: Text(
                            tags[index].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      if(isActivateList[index]){
                        _tagBloc.emitEvent(TagEventSelectDeactivate(index: index));
                      }
                      else if(!isActivateList[index]){
                        _tagBloc.emitEvent(TagEventSelectActivate(index: index));
                      }
                    },
                  );
                }
              );
            }
          ),
          BlocBuilder(
            bloc: _tagBloc,
            builder: (context, TagState state){
              return InitialButton(
                text: '선택 완료',
                color: primaryBeige,
                callback: state.isTagCompleted
                ? (){
                  
                } 
                : null,
              );
            }
          )
        ]
      )
    );
  }
}