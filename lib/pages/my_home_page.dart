import 'package:flutter/material.dart';
import 'package:tsukulog/models/user.dart';
import 'package:tsukulog/components/user_button.dart';
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
  ['株式会社日立製作所', 'LINEヤフー株式会社'],
  ['株式会社スプリックス'],
  ['株式会社インフラトップ', '株式会社Techouse', '株式会社レアゾン・ホールディングス'],
  ['株式会社カフェラテ', '株式会社ゆめみ', '株式会社しびっくぱわー'],
];

final List<List<String>> _tags = [
  [
    'フルスタック',
    'Ruby',
    'Rails',
    'Flutter',
    'Swift',
    '短期ハッカソン',
    '長期インターン',
    '短期インターン',
    'ベンチャー',
    '資格'
    'enPiT'
  ],
  [
    'フロントエンド',
    'Rails',
    'UI/UX',
    'デザイン'
    '短期ハッカソン',
    'サマーインターン',
    '短期インターン',
    'メガベンチャー',
    '大手',
    'enPiT'
  ],
  [
    'データサイエンス',
    'Python',
    'Flutter',
    '機械学習',
    'AI',
    'アルゴリズム',
    '長期インターン',
    'メガベンチャー',
    '資格'
    'enPiT'
  ],
  [
    'フルスタック',
    'Ruby',
    'Rails',
    'JavaScript',
    'Flutter',
    'Swift',
    '長期インターン'
    '長期ハッカソン'
    'ベンチャー',
    '資格'
    'enPiT'
  ],
  [
    'バックエンド'
    'モバイル開発',
    'Flutter',
    'AI'
    '短期ハッカソン',
    '長期インターン',
    '受賞'
    '資格'
    'enPiT'
  ],
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

                    return UserButton(
                        user: user, tags: tags, companies: companies);
                  },
                ),
    );
  }
}
