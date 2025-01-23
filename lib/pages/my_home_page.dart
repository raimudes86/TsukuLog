import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:tsukulog/main.dart';
import 'package:tsukulog/models/user.dart';
import 'package:tsukulog/components/user_button.dart';
import 'package:tsukulog/pages/my_page.dart';
import 'package:tsukulog/pages/right_modal_page.dart';
import 'package:tsukulog/pages/sign_in_page.dart';
import 'package:tsukulog/pages/sign_up_page.dart';
import 'package:tsukulog/pages/show_page.dart';
import 'package:tsukulog/repositories/user_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.isLoggedin});
  final String title;
  final bool isLoggedin;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true; // データ取得中かどうか
  List<User> _users = []; // 取得したユーザーリスト
  List<User> _usersData = []; //ずっと固定しておく元データ(フィルターで消えちゃわないように)
  String? _errorMessage; // エラーメッセージ
  int? _choiceIndex = 0; //並び替えボタン
  List<String> _selectedGrades = []; //選択された学年
  List<String> _selectedFuture = []; //選択された進路
  List<String> _selectedMajor = []; //選択された学科
  User? _me;

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
    _fetchUsersAndSetMe(); // 初期化時にデータを取得
  }

  Future<void> _fetchUsersAndSetMe() async {
    try {
      List<User> users = await UserRepository().fetchAllUsers();
      final currentUser = auth.FirebaseAuth.instance.currentUser;

      // ログインしているユーザーの情報を_meにセット
      if (currentUser != null) {
        final me = users.firstWhere((user) => user.id == currentUser.uid);
        setState(() {
          _me = me;
        });
      }

      // 自分以外のユーザーを_usersに入れる
      if (currentUser != null) {
        users = users.where((user) => user.id != currentUser.uid).toList();
      }

      //初期にいい感じの人を上に持ってくる
      users.sort((a, b) => b.tags.length.compareTo(a.tags.length));
      users.sort((a, b) => b.companies.length.compareTo(a.companies.length));
      users.sort((a, b) => b.like.compareTo(a.like));

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
        actions: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _me != null
                  //ログインしている場合にアイコンと名前を表示
                  ? GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyPage(uid: _me!.id),
                          ),
                        );

                        // MyPage から戻ったときにデータを更新
                        _fetchUsersAndSetMe();
                      },
                      child: MyAccount(me: _me),
                    )
                  : Row(
                      children: [
                        Text("ゲスト", style: TextStyle(color: Colors.black)),
                        SizedBox(width: 16),
                      ],
                    ),
        ],
      ),
      //タイトルに左のメニューバーのこと(drawer)
      drawer: buildDrawer(context, menuList, widget.isLoggedin, _me),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Center(
                  child: Column(
                    //並び替えと絞り込みのボタン
                    children: [
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Spacer(),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<int>(
                                value: _choiceIndex,
                                onChanged: (value) {
                                  setState(() {
                                    _choiceIndex = value!;
                                    if (value == 0) {
                                      _users.sort(
                                          (a, b) => b.like.compareTo(a.like));
                                    } else if (value == 1) {
                                      _users.sort((a, b) => b.companies.length
                                          .compareTo(a.companies.length));
                                    } else if (value == 2) {
                                      _users.sort((a, b) => b.tags.length
                                          .compareTo(a.tags.length));
                                    }
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('いいね順'),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('企業数順'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('タグの数順'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              _showRightSlideModal(context);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.tune, size: 28),
                                Text('絞り込み'),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, i) {
                            final user = _users[i];
                            return GestureDetector(
                              onTap: () async {
                                // ShowPage への遷移
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShowPage(uid: user.id),
                                  ),
                                );

                                // ShowPage から戻ったときにデータを更新
                                _fetchUsersAndSetMe();
                              },
                              child: UserButton(user: user),
                            );
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
        // ignore: deprecated_member_use
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, animation, secondaryAnimation) {
          //モーダルのウィジェットを呼び出す
          return RightModalPage(
              grades: _selectedGrades,
              futures: _selectedFuture,
              majors: _selectedMajor);
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

        _users = result["grades"].isNotEmpty
            ? _users
                .where((user) => result["grades"].contains(user.grade))
                .toList()
            : _users;

        _users = result["futures"].isNotEmpty
            ? _users
                .where((user) => result["futures"].contains(user.futurePath))
                .toList()
            : _users;

        _users = result["majors"].isNotEmpty
            ? _users
                .where((user) => result["majors"].contains(user.major))
                .toList()
            : _users;

        //次に検索を開いたときに状態を復元するために渡す変数を更新
        _selectedGrades = result["grades"];
        _selectedFuture = result["futures"];
        _selectedMajor = result["majors"];
      });
    }
  }
}

class MyAccount extends StatelessWidget {
  const MyAccount({
    super.key,
    required User? me,
  }) : _me = me;

  final User? _me;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      CircleAvatar(
        radius: 20,
        // backgroundColor: Colors.blueGrey,
        backgroundImage: _me!.selectedIcon > 0 && _me!.selectedIcon < 10
            ? AssetImage('assets/images/icon${_me!.selectedIcon}.webp')
            : null, // _me!.selectedIconに基づいて画像パスを生成
        child: _me!.selectedIcon < 1 || _me!.selectedIcon > 9
            ? Text(
                _me!.nickname.isNotEmpty
                    ? _me!.nickname[0] // 名前のイニシャルを表示
                    : '仮',
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              )
            : null,
      ),
      SizedBox(width: 16),
    ]);
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

Drawer buildDrawer(
    BuildContext context, List<String> menuList, bool isloggedin, User? me) {
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
                    builder: (context) =>
                        MyHomePage(title: 'つくログ', isLoggedin: isloggedin),
                  ),
                );
              }),
              if (isloggedin)
                listTile('プロフィール閲覧・編集', Icons.person, () {
                  Navigator.push(
                    context,
                    //マイページへの遷移を記述する
                    MaterialPageRoute(
                      builder: (context) => MyPage(uid: me!.id),
                    ),
                  );
                }),
              if (isloggedin)
                listTile('ログアウト', Icons.logout, () {
                  auth.FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyApp(),
                    ),
                  );
                }),
              if (!isloggedin)
                listTile('ログイン', Icons.login, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignInPage(),
                    ),
                  );
                }),
              if (!isloggedin)
                listTile('新規登録', Icons.person_add, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),
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
