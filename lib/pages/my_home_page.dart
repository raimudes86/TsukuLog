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

  // 一旦関連企業用に作成したデータ
  final List<List<String>> _companies = [
    ['ライザップテクノロジーズ株式会社', '株式会社エスピック', '株式会社Techouse'],
    ['株式会社インフラトップ', '株式会社Techouse','LINEヤフー株式会社']
  ];

  // ユーザーに付随するタグのサンプルデータ
  final List<List<String>> _tags = [
    ['バックエンド', 'Rails', 'Next.js', 'Swift', '短期ハッカソン', '長期インターン', '短期インターン','資格'],
    ['フルスタック', 'Rails', 'flutter', '長期ハッカソン', 'サマーインターン', '長期インターン','メガベンチャー','人工生命','資格']
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // 初期化時にデータを取得
  }

  Future<void> _fetchUsers() async {
    try {
      // Firestoreなどからデータを取得
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, i) {
                    final user = _users[i];
                    final companies =
                        _companies[i % _companies.length]; // サンプルデータのループ利用
                    final tags = _tags[i % _tags.length]; // タグのサンプルデータ

                    return GestureDetector(
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
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 仮アイコン
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blueGrey,
                                    child: Text(
                                      user.nickname.isNotEmpty
                                          ? user.nickname[0] // 名前のイニシャルを表示
                                          : '仮',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16.0),

                                  // majorとgradeを表示
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.major} ${user.grade}',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Text(
                                            user.futurePath,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700],                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        user.nickname,
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 20.0,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(
                                            user.star.toString(),
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),

                              // タグ表示
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: tags.map((tag) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16.0),

                              // 関連企業リスト
                              Row(
                                children: [
                                  const Icon(Icons.apartment),
                                  const SizedBox(width: 8.0),
                                  const Text(
                                    '関連企業',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              ...companies.map(
                                (company) => Text(
                                  company,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
