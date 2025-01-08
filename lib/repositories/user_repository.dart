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
          .collection('carrer_history')
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

    //コレクションのインスタンスから、中身の取得とUserに渡すリストの作成
    List<Map<String, dynamic>> careerData =
        careerSnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> qualificationData =
        qualificationSnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> lessonData =
        lessonSnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> portfolioData =
        portFolioSnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> clubData =
        clubSnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> suggestData =
        suggestSnapshot.docs.map((doc) => doc.data()).toList();
    Map<String, dynamic>? bestCareer = careerSnapshot.docs
        .firstWhereOrNull(
          (doc) => doc.id == userDoc.data()!['best_career_id'],
        )
        ?.data();

    //careerDataを日付順にソート
    const sortMap = {
      'B1': 1,
      'B2': 2,
      'B3': 3,
      'M1': 4,
      'M2': 5,
      'D1': 6,
      'D2': 7,
      'D3': 8
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
        bestCareer,
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
}
