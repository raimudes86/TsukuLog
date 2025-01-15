import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:tsukulog/main.dart';
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
  List<User> _usersData = []; //ずっと固定しておく元データ(フィルターで消えちゃわないように)
  String? _errorMessage; // エラーメッセージ
  int? _choiceIndex; //並び替えボタン
  String? _selectedGrade;
  String? _selectedFuture;
  final menuList = [
    "ユーザー一覧",
    "プロフィール閲覧・編集",
    "ログアウト",
  ];
  final sortMap = {
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
          .where((user) =>
              user.id != auth.FirebaseAuth.instance.currentUser!.uid &&
              user.careerHistories.isNotEmpty)
          .toList();

      // データをセットしてUIを更新
      setState(() {
        _users = users;
        _usersData = users;
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
              : Center(
                  child: Column(
                    children: [
                      Row(spacing: 10, children: [
                        SizedBox(width: 8),
                        ChoiceChip(
                            label: Text("いいね順"),
                            selected: _choiceIndex == 0,
                            // backgroundColor: Colors.grey[600],
                            selectedColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            onSelected: (_) {
                              setState(() {
                                _choiceIndex = 0;
                                _users.sort((a, b) => b.like.compareTo(a.like));
                              });
                            }),
                        ChoiceChip(
                            label: Text("学年順"),
                            selected: _choiceIndex == 1,
                            // backgroundColor: Colors.grey[600],
                            selectedColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            onSelected: (_) {
                              setState(() {
                                _choiceIndex = 1;
                                _users.sort((a, b) {
                                  int gradeA = sortMap[a.grade] ?? 0;
                                  int gradeB = sortMap[b.grade] ?? 0;
                                  return gradeA.compareTo(gradeB);
                                });
                              });
                            }),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            _showRightSlideModal(context);
                          },
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.tune, size: 28),
                            Text('絞り込み'),
                          ]),
                        ),
                        SizedBox(width: 8),
                      ]),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, i) {
                            final user = _users[i];
                            return UserButton(user: user);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  //右から出てくるモーダルを呼び出すメソッド
  void _showRightSlideModal(BuildContext context) async {
    //閉じた時に選択された学年と進路の入ったリストをresultで受け取る
    final result = await Navigator.of(context).push(
      //出てくるページの設定
      //ここではこのメソッドの下に定義したRightModalPageクラスのWidgetを呼び出す
      PageRouteBuilder(
        opaque: false, // 背景を透過する設定
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) {
          //モーダルのウィジェットを呼び出す
          return RightModalPage(
              searchParams: [_selectedGrade, _selectedFuture]);
        },
        //画面遷移の設定
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 右端から開始
          const end = Offset(0.0, 0.0); // 画面の左端まで開く(出てくるぺーじを80%に縮小してるからこれで良い)
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    //モーダルから返された値を使って処理
    if (result != null) {
      setState(() {
        //データをリフレッシュ
        _users = _usersData;
        //学年でフィルター
        _users = result[0] != null
            ? _users.where((user) => user.grade == result[0]).toList()
            : _users;
        //進路でフィルター
        _users = result[1] != null
            ? _users.where((user) => user.futurePath == result[1]).toList()
            : _users;

        //次に検索を開いたときに状態を復元するために渡す変数を更新
        _selectedGrade = result[0];
        _selectedFuture = result[1];
      });
    }
  }
}

//右から召喚されるページの設定
class RightModalPage extends StatefulWidget {
  const RightModalPage({super.key, required this.searchParams});
  final List<String?> searchParams;

  @override
  State<RightModalPage> createState() => _RightModalPageState();
}

class _RightModalPageState extends State<RightModalPage> {
  String? _selectedGrade;
  String? _selectedFuture;

  @override
  void initState() {
    super.initState();
    // 呼び出し元からの配列をモーダル内変数に割り当て
    _selectedGrade = widget.searchParams[0];
    _selectedFuture = widget.searchParams[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 背景を透過
      body: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // 画面サイズの8割のページを作る
          color: Colors.white,
          child: Column(
            children: [
              AppBar(
                title: Text('絞り込み'),
                //leadingでタイトルに左に配置できる
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () =>
                      Navigator.pop(context, [_selectedGrade, _selectedFuture]),
                ),
                //actionsでタイトルの右に配置できる
                actions: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFuture = null;
                        _selectedGrade = null;
                      });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0), // 左右に余白を追加
                      child: Text('クリア', style: TextStyle(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 8.0),
                          Text("学年", style: TextStyle(fontSize: 16.0)),
                          Spacer(),
                          DropdownButton<String>(
                            hint: Text('絞りたい学年を選択'),
                            value: _selectedGrade,
                            items: [
                              "B1",
                              "B2",
                              "B3",
                              "B4",
                              "M1",
                              "M2",
                              "D1",
                              "D2",
                              "D3"
                            ].map((grade) {
                              return DropdownMenuItem(
                                value: grade,
                                child: Text(grade),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGrade = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 8.0),
                          Text("進路", style: TextStyle(fontSize: 16.0)),
                          Spacer(),
                          DropdownButton<String>(
                            hint: Text('絞りたい進路を選択'),
                            value: _selectedFuture,
                            items: [
                              "院進",
                              "就職",
                              "院進or就職",
                            ].map((future) {
                              return DropdownMenuItem(
                                value: future,
                                child: Text(future),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedFuture = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              minimumSize: Size(100, 50),
                            ),
                            onPressed: () {
                              Navigator.pop(
                                  context, [_selectedGrade, _selectedFuture]);
                            },
                            child: Text('検索する'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
                    builder: (context) => MyApp(),
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
