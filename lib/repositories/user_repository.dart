import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import '../models/user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User> fetchUser(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firestore.collection('users').doc(userId).get();

//FirebaseFirestore型のサブコレクションの取得
    final futures = await Future.wait([
      _firestore
          .collection('users')
          .doc(userId)
          .collection('career_history')
          .get(),
      _firestore
          .collection('users')
          .doc(userId)
          .collection('qualification')
          .get(),
      _firestore.collection('users').doc(userId).collection('lesson').get(),
      _firestore.collection('users').doc(userId).collection('portfolio').get(),
      _firestore.collection('users').doc(userId).collection('club').get(),
      _firestore.collection('users').doc(userId).collection('suggest').get(),
    ]);

    final careerSnapshot = futures[0];
    final qualificationSnapshot = futures[1];
    final lessonSnapshot = futures[2];
    final portFolioSnapshot = futures[3];
    final clubSnapshot = futures[4];
    final suggestSnapshot = futures[5];

    //下で使うヘルパーメソッド
    //idを追加するにはこれしか方法がないっぽい？
    List<Map<String, dynamic>> appendIdAndMakeList(
        QuerySnapshot<Map<String, dynamic>> snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        return {
          ...data,
          'id': doc.id,
        };
      }).toList();
    }

    //ヘルパーメソッドによってサブコレクションのデータをリストに変換
    final careerData = appendIdAndMakeList(careerSnapshot);
    final qualificationData = appendIdAndMakeList(qualificationSnapshot);
    final lessonData = appendIdAndMakeList(lessonSnapshot);
    final portfolioData = appendIdAndMakeList(portFolioSnapshot);
    final clubData = appendIdAndMakeList(clubSnapshot);
    final suggestData = appendIdAndMakeList(suggestSnapshot);

    //careerDataを日付順にソート
    const sortMap = {
      'B1': 1,
      'B2': 2,
      'B3': 3,
      'B4': 4,
      'M1': 5,
      'M2': 6,
      'D1': 7,
      'D2': 8,
      'D3': 9,
    };
    careerData.sort((a, b) {
      int gradeA = sortMap[a['start_grade']] ?? 0;
      int gradeB = sortMap[b['start_grade']] ?? 0;
      int gradeDiff = gradeA.compareTo(gradeB);
      if (gradeDiff != 0) {
        return gradeDiff;
      }
      return a['start_month'].compareTo(b['start_month']);
    });
    qualificationData.sort((a, b) {
      return a['year'].compareTo(b['year']);
    });

    //Userの作成
    if (userDoc.exists) {
      return User.fromFirestore(
        userDoc.id,
        userDoc.data()!,
        careerData,
        qualificationData,
        lessonData,
        portfolioData,
        clubData,
        suggestData,
      );
    } else {
      throw Exception('User not found');
    }
  }

  Future<List<User>> fetchAllUsers() async {
    //全ユーザードキュメントを取得
    QuerySnapshot<Map<String, dynamic>> userSnapshot =
        await _firestore.collection('users').get();
    //各ユーザーのIDを取得してfetchUserを呼び出す
    final userIds = userSnapshot.docs.map((doc) => doc.id).toList();

    //全ユーザーのリストを作成
    return Future.wait(userIds.map((userId) => fetchUser(userId)));
  }
}
