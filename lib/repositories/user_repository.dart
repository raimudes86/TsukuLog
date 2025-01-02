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
      _firestore
          .collection('users')
          .doc(userId)
          .collection('lesson')
          .get(),
      _firestore
          .collection('users')
          .doc(userId)
          .collection('portfolio')
          .get(),
      _firestore
          .collection('users')
          .doc(userId)
          .collection('club')
          .get(),
    ]);

    //それぞれのサブコレクションを、そのままの形で取得
    //.get()で取得した時点でQuerySnapshot<Map<String, dynamic>>型を返している
    //可読性や、型エラーを起こさせないために一応？多分大丈夫だけど
    final careerSnapshot = futures[0] as QuerySnapshot<Map<String, dynamic>>;
    final qualificationSnapshot =
        futures[1] as QuerySnapshot<Map<String, dynamic>>;
    final lessonSnapshot = futures[2] as QuerySnapshot<Map<String, dynamic>>;
    final portFolioSnapshot = futures[3] as QuerySnapshot<Map<String, dynamic>>;
    final clubSnapshot = futures[4] as QuerySnapshot<Map<String, dynamic>>;

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

