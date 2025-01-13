import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:tsukulog/models/user.dart';
import 'package:tsukulog/components/user_button.dart';
import 'package:tsukulog/pages/sign_in_page.dart';
import 'package:tsukulog/repositories/user_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true; // データ取得中かどうか
  List<User> _users = []; // 取得したユーザーリスト
  String? _errorMessage; // エラーメッセージ
  final menuList = [
    "ユーザー一覧",
    "プロフィール閲覧・編集",
    "ログアウト",
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // 初期化時にデータを取得
  }

  Future<void> _fetchUsers() async {
    try {
      List<User> users = await UserRepository().fetchAllUsers();
      // 自分以外のユーザー以外取得
      users = users
          .where(
              (user) => user.id != auth.FirebaseAuth.instance.currentUser!.uid)
          .toList();

      // データをセットしてUIを更新
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      // エラー時の処理
      setState(() {
        _errorMessage = 'データの取得に失敗しました: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: buildDrawer(context, menuList),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, i) {
                    final user = _users[i];
                    return UserButton(user: user);
                  },
                ),
    );
  }
}

Widget listTile(String title, IconData icon, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: Colors.black), // アイコン
    title: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16.0), // 矢印アイコン
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0), // パディング調整
  );
}

Drawer buildDrawer(BuildContext context, List<String> menuList) {
  return Drawer(
    child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: Center(
            child: Text(
              'メニュー',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              listTile('ユーザー一覧', Icons.people, () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'つくログ'),
                  ),
                );
              }),
              listTile('プロフィール閲覧・編集', Icons.person, () {
                // プロフィール閲覧・編集タップ時の動作
              }),
              listTile('ログアウト', Icons.logout, () {
                auth.FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    ),
  );
}
