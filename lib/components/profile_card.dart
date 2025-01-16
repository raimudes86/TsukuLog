import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:tsukulog/pages/sign_in_page.dart';
import 'package:tsukulog/pages/sign_up_page.dart';

class ProfileCard extends StatefulWidget {
  final String userId; // プロフィールのユーザーID
  final String nickname;
  final String grade;
  final String major;
  final String futurePath;
  final int initialLike;
  final int selectedIcon;

  const ProfileCard({
    super.key,
    required this.userId,
    required this.nickname,
    required this.grade,
    required this.major,
    required this.futurePath,
    required this.initialLike,
    required this.selectedIcon,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int _like = 0; // いいね数を管理
  bool _isLiked = false; // いいね状態を管理
  final auth.User? currentUser = auth.FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _like = widget.initialLike; // いいね数を初期化
    super.initState();
    _checkIfLiked(); // 初期状態でいいね済みか確認
  }

  // Firestoreからいいね済みかを確認
  Future<void> _checkIfLiked() async {
    final likesRef = FirebaseFirestore.instance.collection('likes');
    // ログインしていない場合はいいね済みとしない
    if (currentUser == null) {
      setState(() {
        _isLiked = false;
      });
      return;
    }
    final likeDoc = await likesRef
        .where('fromUserId', isEqualTo: currentUser!.uid)
        .where('toUserId', isEqualTo: widget.userId)
        .get();

    setState(() {
      _isLiked = likeDoc.docs.isNotEmpty;
    });
  }

  // いいねをトグル（追加または削除）
  Future<void> _toggleLike() async {
    final likesRef = FirebaseFirestore.instance.collection('likes');
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(widget.userId);

    if (_isLiked) {
      // いいねを削除
      final likeDoc = await likesRef
          .where('fromUserId', isEqualTo: currentUser!.uid)
          .where('toUserId', isEqualTo: widget.userId)
          .get();

      if (likeDoc.docs.isNotEmpty) {
        await likesRef.doc(likeDoc.docs.first.id).delete();

        // Firestoreでスターをデクリメント
        await userDoc.update({'like': FieldValue.increment(-1)});

        setState(() {
          _like--;
          _isLiked = false;
        });
      }
    } else {
      // いいねを追加
      await likesRef.add({
        'fromUserId': currentUser!.uid,
        'toUserId': widget.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Firestoreでスターをインクリメント
      await userDoc.update({'like': FieldValue.increment(1)});

      setState(() {
        _like++;
        _isLiked = true;
      });
    }
  }

  void _showPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ログインが必要です'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: Text('ログインはこちらから')),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: Text('新規登録はこちらから')),
          ]),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('閉じる'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF9424E3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 星アイコンとスター数
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: currentUser == null ? _showPopUp : _toggleLike,
                child: Row(
                  children: [
                    Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '参考になった $_like',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nickname,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 学年と専攻
                    Text(
                      '${widget.grade}  ${widget.major}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 進路情報
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 230, 230, 230),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '  ${widget.futurePath}  ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    AssetImage('assets/images/icon${widget.selectedIcon}.webp'),
                child: widget.selectedIcon < 1 || widget.selectedIcon > 5
                    ? Text(
                        widget.nickname.isNotEmpty
                            ? widget.nickname[0] // 名前のイニシャルを表示
                            : '仮',
                        style: const TextStyle(
                          fontSize: 48.0,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
