import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CopyDataPage extends StatelessWidget {
  const CopyDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('データコピー'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            const sourceUserId = '2WwoOH3Wadwpaplcyd4a'; // コピー元ユーザーBのID
            const targetUserId = 'b5d3q9UBj3SD67uHJis5uY584dg2'; // コピー先ユーザーAのID

            await copyUserData(sourceUserId, targetUserId);
          },
          child: const Text('データをコピー'),
        ),
      ),
    );
  }

  Future<void> copyUserData(String sourceUserId, String targetUserId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final sourceDoc =
          await firestore.collection('users').doc(sourceUserId).get();

      if (!sourceDoc.exists) {
        debugPrint("元のユーザーデータが見つかりません。");
        return;
      }

      final sourceData = sourceDoc.data();
      await firestore.collection('users').doc(targetUserId).set(sourceData!);
      debugPrint("親ドキュメントをコピーしました。");

      const subcollectionNames = [
        'portfolio',
        'qualification',
        'suggest',
        'lesson',
        'club',
        'career_history',
      ];

      for (final subcollectionName in subcollectionNames) {
        final subcollectionSnapshot = await firestore
            .collection('users')
            .doc(sourceUserId)
            .collection(subcollectionName)
            .get();

        for (final doc in subcollectionSnapshot.docs) {
          await firestore
              .collection('users')
              .doc(targetUserId)
              .collection(subcollectionName)
              .doc(doc.id)
              .set(doc.data());
          debugPrint(
              "サブコレクション '$subcollectionName' のドキュメント '${doc.id}' をコピーしました。");
        }
      }

      debugPrint("すべてのデータをコピーしました。");
    } catch (e) {
      debugPrint("エラーが発生しました: $e");
    }
  }
}
