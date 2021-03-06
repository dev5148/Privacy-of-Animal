import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:privacy_of_animal/logics/chat_list/chat_list.dart';
import 'package:privacy_of_animal/logics/global/current_user.dart';
import 'package:privacy_of_animal/logics/global/database_api.dart';
import 'package:privacy_of_animal/logics/global/firebase_api.dart';
import 'package:privacy_of_animal/logics/global/notification_api.dart';
import 'package:privacy_of_animal/logics/other_profile/other_profile.dart';
import 'package:privacy_of_animal/logics/same_match/same_match.dart';
import 'package:privacy_of_animal/models/chat_list_model.dart';
import 'package:privacy_of_animal/models/chat_model.dart';
import 'package:privacy_of_animal/models/user_model.dart';
import 'package:privacy_of_animal/utils/service_locator.dart';
import 'package:privacy_of_animal/resources/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsAPI {

  UserModel _notifyingFriends, _notifyingRequestFrom;

  /// [친구 알림 설정]
  Future<void> setFriendsNotification() async {
    debugPrint('[친구] 친구 알림 설정');

    SharedPreferences prefs = await sl.get<DatabaseAPI>().sharedPreferences;
    bool value = !sl.get<CurrentUser>().friendsNotification;
    await prefs.setBool(sl.get<CurrentUser>().uid+friendsNotification, value);
    sl.get<CurrentUser>().friendsNotification = value;
  }

  /// [처음 친구 업데이트]
  Future<void> fetchFirstFriends(List<DocumentSnapshot> friendsList) async {
    debugPrint("[친구] 처음 친구 업데이트");

    for(DocumentSnapshot friends in friendsList) {
      DocumentSnapshot friendsSnapshot = await sl.get<FirebaseAPI>().getFirestore()
        .collection(firestoreUsersCollection)
        .document(friends.documentID)
        .get();
      UserModel friendsUserModel = UserModel.fromSnapshot(snapshot: friendsSnapshot);
      await _increaseLocalFriends(friendsUserModel,isFirst: true);
    }
  }

  /// [처음 친구신청 업데이트]
  Future<void> fetchFirstRequest(List<DocumentSnapshot> requestList) async {
    debugPrint("[친구] 처음 친구신청 업데이트");

    for(DocumentSnapshot request in requestList) {
      DocumentSnapshot requestSnapshot = await sl.get<FirebaseAPI>().getFirestore()
        .collection(firestoreUsersCollection)
        .document(request.documentID)
        .get();
      UserModel requestUserModel = UserModel.fromSnapshot(snapshot: requestSnapshot);
      _increaseLocalRequest(requestUserModel);
    }
  }

  /// [친구 증가]
  Future<void> fetchIncreasedFriends(List<DocumentChange> newFriendsList) async {
    debugPrint("[친구] 친구 증가했을 때 데이터 가져오기");

    _setNewFriendsNum(newFriendsList.length);

    for(DocumentChange newFriends in newFriendsList) {
      bool isAccepted = newFriends.document.data[firestoreFriendsAccepted];
      debugPrint("[친구] ${newFriends.document.documentID}, 친구신청 받았는가? : $isAccepted");
      
      DocumentSnapshot newFriendsSnapshot = await sl.get<FirebaseAPI>().
        getUserSnapshot(newFriends.document.documentID);
      UserModel newFriendsUserModel = UserModel.fromSnapshot(snapshot: newFriendsSnapshot);
      await _increaseLocalFriends(newFriendsUserModel,isFirst: false);
      _updateOtherProfileFriends(newFriendsUserModel.uid);
      if(isAccepted) {
        _notifyingFriends ??= newFriendsUserModel;
      }
    }
  }

  void _setNewFriendsNum(int num) {
    debugPrint('[친구] 새로운 친구 수 갱신');

    sl.get<CurrentUser>().newFriendsNum = num;
  }

  void _updateOtherProfileFriends(String otherUserUID) {
    if(otherUserUID == sl.get<CurrentUser>().currentProfileUID) {
      debugPrint("[친구] 프로필 화면과 매칭화면 업데이트");

      sl.get<SameMatchBloc>().emitEvent(SameMatchEventRefreshFriends());
      sl.get<OtherProfileBloc>().emitEvent(OtherProfileEventRefreshFriends());
    }
  }

  void notifyNewFriends() {
    if(_notifyingFriends!=null && sl.get<CurrentUser>().friendsNotification) {
      debugPrint("[친구] 새로운 친구 알림");

      sl.get<NotificationAPI>().showFriendsNotification(_notifyingFriends.fakeProfileModel.nickName);
      _notifyingFriends = null;
    }
  }

  /// [친구 감소]
  Future<void> fetchDecreasedFriends(List<DocumentChange> deletedFriendsList) async {
    debugPrint("[친구] 친구 감소했을 때 데이터 가져오기");

    for(DocumentChange deletedFriends in deletedFriendsList) {
      String deletedFriendsUID = deletedFriends.document.documentID;
      DocumentSnapshot deletedFriendsSnapshot = await sl.get<FirebaseAPI>()
        .getUserSnapshot(deletedFriendsUID);
      UserModel deletedFriendsUserModel = UserModel.fromSnapshot(snapshot: deletedFriendsSnapshot);
      await _decreaseLocalFriends(deletedFriendsUserModel);
      _updateOtherProfileFriends(deletedFriendsUID);
    }
  }

  /// [받은 친구신청 증가]
  Future<void> fetchIncreasedRequestFrom(List<DocumentChange> newRequestFromList) async {
    debugPrint("[친구] 친구신청 증가했을 때 데이터 가져오기");

    for(DocumentChange newRequestFrom in newRequestFromList) {
      DocumentSnapshot newRequestFromSnapshot = await sl.get<FirebaseAPI>()
        .getUserSnapshot(newRequestFrom.document.documentID);
      UserModel newRequestFromUserModel =UserModel.fromSnapshot(snapshot: newRequestFromSnapshot);
      _increaseLocalRequest(newRequestFromUserModel);
      _updateOtherProfileRequest(newRequestFromUserModel.uid);
      _notifyingRequestFrom ??= newRequestFromUserModel;
    }
  }

  void _updateOtherProfileRequest(String otherUserUID) {
    if(otherUserUID == sl.get<CurrentUser>().currentProfileUID) {
      debugPrint("[친구] 프로필 화면과 매칭 화면 업데이트");

      sl.get<SameMatchBloc>().emitEvent(SameMatchEventRefreshRequestFrom());
      sl.get<OtherProfileBloc>().emitEvent(OtherProfileEventRefreshRequestFrom());
    }
  }

  void notifyNewRequestFrom() {
    if(sl.get<CurrentUser>().friendsNotification && _notifyingRequestFrom!=null) {
      debugPrint("[친구] 새로운 친구신청 알림");

      sl.get<NotificationAPI>().showRequestNotification(_notifyingRequestFrom.fakeProfileModel.nickName);
      _notifyingRequestFrom = null;
    }
  }

  /// [친구신청 감소]
  Future<void> fetchDecreasedRequestFrom(List<DocumentChange> deletedRequestFromList) async {
    debugPrint("[친구] 친구신청 감소했을 때 데이터 가져오기");

    for(DocumentChange deletedRequestFrom in deletedRequestFromList) {
      String deletedRequestFromUID = deletedRequestFrom.document.documentID;
      DocumentSnapshot deletedRequestSnapshot = await sl.get<FirebaseAPI>().getFirestore()
        .collection(firestoreUsersCollection)
        .document(deletedRequestFromUID)
        .get();
      UserModel deletedRequestUserModel = UserModel.fromSnapshot(snapshot: deletedRequestSnapshot);
      _decreaseLocalRequest(deletedRequestUserModel);
      _updateOtherProfileRequest(deletedRequestFromUID);
    }
  }


  /// [서버에서 친구 차단]
  Future<void> blockFriendsForServer(UserModel userToBlock) async {
    debugPrint("[친구] 서버에서 친구 차단");

    DocumentReference myselfDoc = sl.get<FirebaseAPI>().getFirestore()
      .collection(firestoreUsersCollection)
      .document(sl.get<CurrentUser>().uid)
      .collection(firestoreFriendsSubCollection)
      .document(userToBlock.uid);

    DocumentReference userToBlockDoc = sl.get<FirebaseAPI>().getFirestore()
      .collection(firestoreUsersCollection)
      .document(userToBlock.uid)
      .collection(firestoreFriendsSubCollection)
      .document(sl.get<CurrentUser>().uid);
      
    QuerySnapshot chatRoomSnapshot = await sl.get<FirebaseAPI>().getFirestore()
      .collection(firestoreFriendsMessageCollection)
      .where('$firestoreChatUsersField.$sl.get<CurrentUser>().uid', isEqualTo: true)
      .where('$firestoreChatUsersField.${userToBlock.uid}', isEqualTo: true)
      .getDocuments();

    WriteBatch batch = sl.get<FirebaseAPI>().getFirestore().batch();

    if(chatRoomSnapshot.documents.isNotEmpty) {
      DocumentReference realChatRoom =chatRoomSnapshot.documents[0].reference;

      QuerySnapshot chatSnapshot = await realChatRoom
      .collection(realChatRoom.documentID)
      .getDocuments();

      for(DocumentSnapshot chat in chatSnapshot.documents) {
        batch.delete(chat.reference);
      }
      batch.delete(realChatRoom);
    }

    batch.delete(myselfDoc);
    batch.delete(userToBlockDoc);
    await batch.commit();
  }

  /// [서버에서 친구신청 수락]
  Future<void> acceptFriendsForServer(UserModel requestFromingUser) async {
    debugPrint("[친구] 서버에서 친구 수락");

    // 먼저 친구신청란에서 지워야 함
    sl.get<CurrentUser>().requestFromList.removeWhere((user) => user.uid == requestFromingUser.uid);

    String currentUser = sl.get<CurrentUser>().uid;

    DocumentReference myselfDoc = sl.get<FirebaseAPI>().getFirestore()
      .collection(firestoreUsersCollection)
      .document(currentUser)
      .collection(firestoreFriendsSubCollection)
      .document(requestFromingUser.uid);

    DocumentReference requestFromingUserDoc = sl.get<FirebaseAPI>().getFirestore()
      .collection(firestoreUsersCollection)
      .document(requestFromingUser.uid)
      .collection(firestoreFriendsSubCollection)
      .document(currentUser);

    DocumentReference chatDoc = sl.get<FirebaseAPI>().getFirestore()
      .collection(firestoreFriendsMessageCollection)
      .document();
    
    WriteBatch batch = sl.get<FirebaseAPI>().getFirestore().batch();

    batch.setData(myselfDoc, {firestoreFriendsField: true},merge: true);
    batch.setData(requestFromingUserDoc, {
      firestoreFriendsField: true,
      firestoreFriendsAccepted: true,
      firestoreFriendsUID: currentUser
    });

    batch.setData(chatDoc, {
      firestoreChatOutField: {
        currentUser: Timestamp(0,0),
        requestFromingUser.uid: Timestamp(0,0)
      },
      firestoreChatDeleteField: {
        currentUser: false,
        requestFromingUser.uid: false
      },
      firestoreChatUsersField: {
        currentUser: true,
        requestFromingUser.uid: true
      }
    });

    await batch.commit();
  }

  /// [서버에서 친구신청 삭제]
  Future<void> rejectFriendsForServer(UserModel userToReject) async {
    debugPrint("[친구] 서버에서 친구신청 삭제");

    DocumentReference doc = sl.get<FirebaseAPI>().getFirestore()
      .collection(firestoreUsersCollection)
      .document(sl.get<CurrentUser>().uid)
      .collection(firestoreFriendsSubCollection)
      .document(userToReject.uid);
    await sl.get<FirebaseAPI>().getFirestore().runTransaction((tx) async{
      await tx.delete(doc);
    });
  }

  /// [친구와 대화]
  Future<String> chatWithFriends(String userToChat) async {
    debugPrint("[친구] 친구와 대화");

    sl.get<CurrentUser>().chatListHistory[userToChat] ??= ChatListModel();
    sl.get<CurrentUser>().chatHistory[userToChat] ??= List<ChatModel>();

    if(sl.get<CurrentUser>().chatListHistory[userToChat].chatRoomID.isEmpty) {
      QuerySnapshot chatRoomSnapshot = await sl.get<FirebaseAPI>().getFirestore()
        .collection(firestoreFriendsMessageCollection)
        .where('$firestoreChatUsersField.${sl.get<CurrentUser>().uid}',isEqualTo: true)
        .where('$firestoreChatUsersField.$userToChat',isEqualTo: true)
        .getDocuments();
      sl.get<CurrentUser>().chatListHistory[userToChat].chatRoomID 
        = chatRoomSnapshot.documents[0].documentID;
    }

    return sl.get<CurrentUser>().chatListHistory[userToChat].chatRoomID;
  }

  /// [로컬에서 친구 감소]
  Future<void> _decreaseLocalFriends(UserModel userToBlock) async{
    debugPrint("[친구] 친구 감소했을 때 로컬에서 업데이트");

    SharedPreferences prefs = await sl.get<DatabaseAPI>().sharedPreferences;
    prefs.remove(userToBlock.uid);

    sl.get<CurrentUser>().friendsList.removeWhere((friends) => friends.uid==userToBlock.uid);
    sl.get<CurrentUser>().chatHistory.remove(userToBlock.uid);
    sl.get<CurrentUser>().chatListHistory.remove(userToBlock.uid);
    sl.get<CurrentUser>().chatRoomNotification.remove(userToBlock.uid);
    sl.get<ChatListBloc>().emitEvent(ChatListEventRefresh());
  }

  /// [로컬에서 친구 증가]
  Future<void> _increaseLocalFriends(UserModel newFriends, {bool isFirst}) async{
    debugPrint("[친구] 처음 혹은 친구 증가했을 때 로컬에서 업데이트");
    if(!isFirst) {
      SharedPreferences prefs = await sl.get<DatabaseAPI>().sharedPreferences;
      await prefs.setBool(newFriends.uid, true);
      sl.get<CurrentUser>().chatRoomNotification[newFriends.uid] = true;
    }
    sl.get<CurrentUser>().friendsList.add(newFriends);
    sl.get<CurrentUser>().chatHistory[newFriends.uid] = [];
  } 

  /// [로컬에서 친구신청 감소]
  void _decreaseLocalRequest(UserModel userToReject) {
    debugPrint("[친구] 친구신청 감소했을 때 로컬에서 업데이트");

    sl.get<CurrentUser>().requestFromList
      .removeWhere((requestingUser)=>requestingUser.uid==userToReject.uid);
  }

  /// [로컬에서 친구신청 증가]
  void _increaseLocalRequest(UserModel requestingUser) {
    debugPrint("[친구] 처음 혹은 친구신청 증가했을 때 로컬에서 업데이트");

    sl.get<CurrentUser>().requestFromList.add(requestingUser);
  }
}