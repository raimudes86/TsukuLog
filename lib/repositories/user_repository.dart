import 'package:cloud_firestore/cloud_firestore.dart';
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
    ]);

    final careerSnapshot = futures[0];
    final qualificationSnapshot = futures[1];
    final lessonSnapshot = futures[2];
    final portFolioSnapshot = futures[3];
    final clubSnapshot = futures[4];

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
      );
    } else {
      throw Exception('User not found');
    }
  }
}
