
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:privacy_of_animal/logics/current_user.dart';
import 'package:privacy_of_animal/logics/database_helper.dart';
import 'package:privacy_of_animal/logics/firebase_api.dart';
import 'package:privacy_of_animal/logics/server_api.dart';
import 'package:privacy_of_animal/resources/strings.dart';
import 'package:privacy_of_animal/utils/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class HomeAPI {

  static Stream<QuerySnapshot> friendsRequestStream = Stream.empty();
  static Stream<QuerySnapshot> friendsStream = Stream.empty();

  // void _setFriendsNotification() {
  //   _addListenerToFriendsRequest();
  //   _addListenerToFriends();
  // }

  // void _addListenerToFriendsRequest() {
  //   friendsRequestStream = sl.get<FirebaseAPI>().getFirestore()
  //     .collection(firestoreUsersCollection).document(sl.get<CurrentUser>().uid)
  //     .collection(firestoreFriendsSubCollection).where(firestoreFriendsField, isEqualTo: false)
  //     .snapshots();
  //   friendsRequestStream.listen((snapshot){
  //     if(snapshot.documents.isNotEmpty && snapshot.documentChanges.isNotEmpty){
  //       if(sl.get<CurrentUser>().friendsRequestListLength==-1) {
  //         sl.get<CurrentUser>().friendsRequestListLength = snapshot.documents.length;
  //       }
  //       else if(snapshot.documentChanges.length==1 
  //         && sl.get<CurrentUser>().friendsRequestListLength < snapshot.documents.length
  //         && sl.get<CurrentUser>().friendsNotification) {
  //           sl.get<CurrentUser>().friendsRequestListLength = snapshot.documents.length;
  //           sl.get<NotificationHelper>().showFriendsRequestNotification(snapshot);
  //       }
  //     }
  //   });
  // }

  // void _addListenerToFriends() {
  //   friendsStream = sl.get<FirebaseAPI>().getFirestore()
  //     .collection(firestoreUsersCollection).document(sl.get<CurrentUser>().uid)
  //     .collection(firestoreFriendsSubCollection)
  //     .where(firestoreFriendsField, isEqualTo: true)
  //     .where(firestoreFriendsAccepted, isEqualTo: true)
  //     .snapshots();
  //   friendsStream.listen((snapshot){
  //     if(snapshot.documents.isNotEmpty && snapshot.documentChanges.isNotEmpty){
  //       if(sl.get<CurrentUser>().friendsListLength==-1) {
  //         sl.get<CurrentUser>().friendsListLength = snapshot.documents.length;
  //       }
  //       else if(snapshot.documentChanges.length==1
  //         && sl.get<CurrentUser>().friendsListLength < snapshot.documents.length
  //         && sl.get<CurrentUser>().friendsNotification) {
  //           sl.get<NotificationHelper>().showFriendsNotification(snapshot);
  //         }
  //     } else {
  //       sl.get<CurrentUser>().friendsListLength = 0;
  //     }
  //   });
  // }


  // 바로 홈 화면으로 갈 경우 그에 해당하는 데이터를 가져옴
  Future<void> fetchUserData() async {
    if(sl.get<CurrentUser>().isDataFetched) { return; }

    await _checkDBAndCallFirestore();
    String uid = sl.get<CurrentUser>().uid;
    Database db = await sl.get<DatabaseHelper>().database;

    // 태그 정보 가져오기
    var tags = await db.rawQuery('SELECT * FROM $tagTable WHERE $uidCol="$uid"');
    _setTagData(tags);

    // 실제 프로필 정보 가져오기
    var realProfile = await db.rawQuery('SELECT * FROM $realProfileTable WHERE $uidCol="$uid"');
    _setRealProfile(realProfile);

    // 가상 프로필 정보 가져오기
    var fakeProfile = await db.rawQuery('SELECT * FROM $fakeProfileTable WHERE $uidCol="$uid"');
    _setFakeProfile(fakeProfile);

    // 알림 설정 가져오기
    await _setNotification(uid);
    //_setFriendsNotification();

    // 친구목록, 친구신청목록과의 스트림 연결작업
    await sl.get<ServerAPI>().connectFriendsList();
    await sl.get<ServerAPI>().connectFriendsRequestList();
    await sl.get<ServerAPI>().connectAllChatRoom();

    // 데이터 가져왔다고 설정
    sl.get<CurrentUser>().isDataFetched = true;
  }

  void _setTagData(List<Map<String,dynamic>> tags) {
    sl.get<CurrentUser>().tagListModel.tagTitleList.add(tags[0][tagName1Col]);
    sl.get<CurrentUser>().tagListModel.tagTitleList.add(tags[0][tagName2Col]);
    sl.get<CurrentUser>().tagListModel.tagTitleList.add(tags[0][tagName3Col]);
    sl.get<CurrentUser>().tagListModel.tagTitleList.add(tags[0][tagName4Col]);
    sl.get<CurrentUser>().tagListModel.tagTitleList.add(tags[0][tagName5Col]);
    sl.get<CurrentUser>().tagListModel.tagDetailList.add(tags[0][tagDetail1Col]);
    sl.get<CurrentUser>().tagListModel.tagDetailList.add(tags[0][tagDetail2Col]);
    sl.get<CurrentUser>().tagListModel.tagDetailList.add(tags[0][tagDetail3Col]);
    sl.get<CurrentUser>().tagListModel.tagDetailList.add(tags[0][tagDetail4Col]);
    sl.get<CurrentUser>().tagListModel.tagDetailList.add(tags[0][tagDetail5Col]);
  }

  void _setRealProfile(List<Map<String,dynamic>> realProfile) {
    sl.get<CurrentUser>().realProfileModel.name = realProfile[0][nameCol];
    sl.get<CurrentUser>().realProfileModel.age = realProfile[0][ageCol];
    sl.get<CurrentUser>().realProfileModel.gender = realProfile[0][genderCol];
    sl.get<CurrentUser>().realProfileModel.job = realProfile[0][jobCol];
  }

  void _setFakeProfile(List<Map<String,dynamic>> fakeProfile) {
    sl.get<CurrentUser>().fakeProfileModel.nickName = fakeProfile[0][nickNameCol];
    sl.get<CurrentUser>().fakeProfileModel.age = fakeProfile[0][fakeAgeCol];
    sl.get<CurrentUser>().fakeProfileModel.gender = fakeProfile[0][fakeGenderCol];
    sl.get<CurrentUser>().fakeProfileModel.emotion = fakeProfile[0][fakeEmotionCol];
    sl.get<CurrentUser>().fakeProfileModel.ageConfidence = fakeProfile[0][fakeAgeConfidenceCol];
    sl.get<CurrentUser>().fakeProfileModel.genderConfidence = fakeProfile[0][fakeGenderConfidenceCol];
    sl.get<CurrentUser>().fakeProfileModel.emotionConfidence = fakeProfile[0][fakeEmotionConfidenceCol];
    sl.get<CurrentUser>().fakeProfileModel.animalName = fakeProfile[0][animalNameCol];
    sl.get<CurrentUser>().fakeProfileModel.animalImage = fakeProfile[0][animalImageCol];
    sl.get<CurrentUser>().fakeProfileModel.animalConfidence = fakeProfile[0][animalConfidenceCol];
    sl.get<CurrentUser>().fakeProfileModel.celebrity = fakeProfile[0][celebrityCol];
    sl.get<CurrentUser>().fakeProfileModel.celebrityConfidence = fakeProfile[0][celebrityConfidenceCol];
    sl.get<CurrentUser>().fakeProfileModel.analyzedTime = fakeProfile[0][analyzedTimeCol];
  }

  Future<void> _setNotification(String uid) async{
    SharedPreferences prefs = await sl.get<DatabaseHelper>().sharedPreferences;
    if(prefs.getBool(uid+friendsNotification)==null){
      prefs.setBool(uid+friendsNotification, false);
      sl.get<CurrentUser>().friendsNotification = false;
    } else {
      sl.get<CurrentUser>().friendsNotification = prefs.getBool(uid+friendsNotification);
    }
  }

  // 로컬 DB체크한 후에 없으면 서버에서 가져옴
  Future<void> _checkDBAndCallFirestore() async {
    Database db = await sl.get<DatabaseHelper>().database;
    List tags = await db.rawQuery('SELECT * FROM $tagTable WHERE $uidCol="${sl.get<CurrentUser>().uid}"');
    if(tags.length==0){
      await _fetchTagsFromFirestore();
    }

    List realProfile = await db.rawQuery('SELECT * FROM $realProfileTable WHERE $uidCol="${sl.get<CurrentUser>().uid}"');
    if(realProfile.length==0){
      await _fetchRealProfileFromFirestore();
    }

    List fakeProfile = await db.rawQuery('SELECT * FROM $fakeProfileTable WHERE $uidCol="${sl.get<CurrentUser>().uid}"');
    if(fakeProfile.length==0){
      await _fetchFakeProfileFromFirestore();
    }
  }

  Future<void> _fetchFakeProfileFromFirestore() async {
    CollectionReference col = sl.get<FirebaseAPI>().getFirestore().collection(firestoreUsersCollection);
    DocumentSnapshot doc = await col.document(sl.get<CurrentUser>().uid).get();
    Database db = await sl.get<DatabaseHelper>().database;
    await db.rawInsert(
      'INSERT INTO $fakeProfileTable ($uidCol,$nickNameCol,$fakeAgeCol,$fakeGenderCol,$fakeEmotionCol,'
      '$fakeAgeConfidenceCol,$fakeGenderConfidenceCol,$fakeEmotionConfidenceCol,'
      '$animalNameCol,$animalImageCol,$animalConfidenceCol,$celebrityCol,$celebrityConfidenceCol,$analyzedTimeCol) VALUES('
      '"${sl.get<CurrentUser>().uid}",'
      '"${doc.data[firestoreFakeProfileField][firestoreNickNameField]}","${doc.data[firestoreFakeProfileField][firestoreFakeAgeField]}",'
      '"${doc.data[firestoreFakeProfileField][firestoreFakeGenderField]}","${doc.data[firestoreFakeProfileField][firestoreFakeEmotionField]}",'
      '"${doc.data[firestoreFakeProfileField][firestoreFakeAgeConfidenceField]}","${doc.data[firestoreFakeProfileField][firestoreFakeGenderConfidenceField]}",'
      '"${doc.data[firestoreFakeProfileField][firestoreFakeEmotionConfidenceField]}","${doc.data[firestoreFakeProfileField][firestoreAnimalNameField]}",'
      '"${doc.data[firestoreFakeProfileField][firestoreAnimalImageField]}","${doc.data[firestoreFakeProfileField][firestoreAnimalConfidenceField]}",'
      '"${doc.data[firestoreFakeProfileField][firestoreCelebrityField]}","${doc.data[firestoreFakeProfileField][firestoreCelebrityConfidenceField]}",'
      '"${doc.data[firestoreFakeProfileField][firestoreAnalyzedTimeField]}")'
    );
  }

  Future<void> _fetchRealProfileFromFirestore() async {
    CollectionReference col = sl.get<FirebaseAPI>().getFirestore().collection(firestoreUsersCollection);
    DocumentSnapshot doc = await col.document(sl.get<CurrentUser>().uid).get();
    Database db = await sl.get<DatabaseHelper>().database;
    await db.rawInsert(
      'INSERT INTO $realProfileTable ($uidCol,$nameCol,$ageCol,$genderCol,$jobCol) VALUES('
      '"${sl.get<CurrentUser>().uid}",'
      '"${doc.data[firestoreRealProfileField][firestoreNameField]}","${doc.data[firestoreRealProfileField][firestoreAgeField]}",'
      '"${doc.data[firestoreRealProfileField][firestoreGenderField]}","${doc.data[firestoreRealProfileField][firestoreJobField]}")'
    );
  }

  Future<void> _fetchTagsFromFirestore() async {
    CollectionReference col = sl.get<FirebaseAPI>().getFirestore().collection(firestoreUsersCollection);
    DocumentSnapshot doc = await col.document(sl.get<CurrentUser>().uid).get();
    Database db = await sl.get<DatabaseHelper>().database;
    await db.rawInsert(
      'INSERT INTO $tagTable ($uidCol,$tagName1Col,$tagName2Col,$tagName3Col,$tagName4Col,$tagName5Col,'
      '$tagDetail1Col,$tagDetail2Col,$tagDetail3Col,$tagDetail4Col,$tagDetail5Col) VALUES('
      '"${sl.get<CurrentUser>().uid}",'
      '"${doc.data[firestoreTagField][firestoreTagTitle1Field]}","${doc.data[firestoreTagField][firestoreTagTitle2Field]}",'
      '"${doc.data[firestoreTagField][firestoreTagTitle3Field]}","${doc.data[firestoreTagField][firestoreTagTitle4Field]}",'
      '"${doc.data[firestoreTagField][firestoreTagTitle5Field]}","${doc.data[firestoreTagField][firestoreTagDetail1Field]}",'
      '"${doc.data[firestoreTagField][firestoreTagDetail2Field]}","${doc.data[firestoreTagField][firestoreTagDetail3Field]}",'
      '"${doc.data[firestoreTagField][firestoreTagDetail4Field]}","${doc.data[firestoreTagField][firestoreTagDetail5Field]}")'
    );
  }
}

enum TAB {
  MATCH,
  CHAT,
  FRIENDS,
  PROFILE
}