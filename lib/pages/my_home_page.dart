import 'package:flutter/material.dart';
import 'package:tsukulog/models/user.dart';
import 'package:tsukulog/pages/show_page.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // 初期化時にデータを取得
  }

  Future<void> _fetchUsers() async {
    try {
      // データを取得
      List<User> users = await UserRepository().fetchAllUsers();

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
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            // for (User user in _users)
            //   ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         minimumSize: Size(200, 50),
            //       ),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) =>
            //                   ShowPage(uid: user.id)),
            //         );
            //       },
            //       child: Text(user.nickname)),
            //   const SizedBox(height: 16),
            for (User user in _users)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowPage(uid: user.id),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ユーザーの名前と参考人数 (星アイコン付き)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.nickname,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20.0,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                user.star.toString(),
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),

                      // 学年と専攻
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '学年: ${user.grade}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            '学類: ${user.major}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),

                      // 進路
                      Text(
                        '進路: ${user.futurePath}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
