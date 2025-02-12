import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tsukulog/pages/my_home_page.dart';
import 'package:tsukulog/pages/sign_in_page.dart';
import 'dart:math';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

enum RadioValue {
  first('大学'),
  second("大学院");

  final String displayName;
  const RadioValue(this.displayName);
}

class _SignUpPageState extends State<SignUpPage> {
  // FirebaseAuthのインスタンスを取得
  final _auth = FirebaseAuth.instance;
  //firestoreのインスタンスを取得
  final _firestore = FirebaseFirestore.instance.collection('users');
  //Formの状態を管理するためのkeyを設定
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _nickname = '';
  //発生したエラーメッセージを格納する変数
  String _errorMessage = '';
  //大学か大学院かのラジオボタンの値を保持する変数
  RadioValue? _academicStage = RadioValue.first;
  //学年
  String? _grade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        //FormウィジェットでTextFormFieldを囲うことで、
        //ボタン押したときなどに、一斉にバリデーションチェックなどが可能になる
        child: Form(
          //ここでFormの状態を管理するためのkeyを設定
          key: _formKey,
          child: Column(
            children: [
              //ただのTextFieldではなく、TextFormFieldを使うことで、
              //Formのバリデーションチェックが可能になる
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'メールアドレス',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.mail)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  }
                  //正規表現でメールアドレスの形式チェック
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'メールアドレスの形式が正しくありません';
                  }
                  return null;
                },
                //送信時のFormState.save()で呼び出される(_formKey.currentState!.save()のように)
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 16.0),

              //パスワード登録
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'パスワード',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '6文字以上のパスワードを入力してください';
                  }
                  if (value.length < 6) {
                    return 'パスワードは6文字以上で入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 16.0),

              //ニックネーム登録
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'ニックネーム',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '10文字以内のニックネームを入力してください';
                  }
                  if (value.length < 2 || value.length > 10) {
                    return 'ニックネームは2~10文字で入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _nickname = value!;
                },
              ),

              const SizedBox(height: 25.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('大学または大学院'),
                  Row(
                    children: [
                      radioButton(RadioValue.first),
                      const Text('大学'),
                      const SizedBox(width: 16.0),
                      radioButton(RadioValue.second),
                      const Text('大学院'),
                    ],
                  ),
                ],
              ),

              //学群学類選択
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _academicStage == RadioValue.first
                    ? [
                        Text('学群'),
                        dropDownCluster(),
                        const SizedBox(height: 16.0),
                        Text('学類'),
                        dropDownMajor(),
                      ]
                    : [
                        Text('学術院'),
                        dropDownFaculty(),
                        const SizedBox(height: 16.0),
                        Text('研究群/専攻'),
                        dropDownDepartment(),
                      ],
              ),
              const SizedBox(height: 16.0),

              //学年選択
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("学年"),
                selectGrade(),
              ]),

              //新規登録ボタン
              ElevatedButton(
                onPressed: () async {
                  // Formのバリデーションチェック
                  //_formKey.cuttentStateで現在のFormStateオブジェクトを取得
                  //このオブジェクトに対してvalidate()メソッドを呼び出すことで、フォーム全体の検証が可能
                  if (_formKey.currentState!.validate()) {
                    //バリデーションが通った場合にauthenticationに保存を試みる
                    //各Form内のonSavedを呼び出して、_emailと_passwordに値をセット
                    _formKey.currentState!.save();
                    try {
                      await _auth.createUserWithEmailAndPassword(
                        email: _email,
                        password: _password,
                      );
                      //debag
                      if (_auth.currentUser != null) {
                        debugPrint("新規登録成功: ${_auth.currentUser!.uid}");
                      }
                      //firestoreにユーザー情報を保存
                      await _firestore.doc(_auth.currentUser!.uid).set({
                        'nickname': _nickname,
                        'like': 0, // 初期値
                        'grade': _grade,
                        'major': _selectedMajor ?? _selectedDepartment,
                        'future_path': '未設定',
                        'best_career_id': '未設定',
                        'selected_icon': Random().nextInt(5) + 1,
                        'tags': [],
                        'companies': [],
                        'created_at': FieldValue.serverTimestamp(),
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        setState(() {
                          _errorMessage = "メールアドレスはすでに登録されています。";
                        });
                      } else {
                        setState(() {
                          _errorMessage = "エラーが発生しました";
                        });
                      }
                    }

                    //非同期処理中に現在のウィジェットが破棄されるとcontextを使用した操作でエラー
                    //mountedプロパティでウィジェットが破棄されていないか確認をしてから画面遷移
                    if (mounted) {
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(title: 'つくログ', isLoggedin: true),
                        ),
                      );
                    }
                  }
                },
                child: const Text('新規登録'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  },
                  child: Text('ログインはこちらから')),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(title: "つくログ", isLoggedin: false)));
                  },
                  child: Text('ゲストとしてログイン')),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> selectGrade() {
    return DropdownButton<String>(
        isExpanded: true,
        items: _academicStage == RadioValue.first
            ? ["B1", "B2", "B3", "B4"].map((grade) {
                return DropdownMenuItem(
                  value: grade,
                  child: Text(grade),
                );
              }).toList()
            : ["M1", "M2", "D1", "D2", "D3"].map((grade) {
                return DropdownMenuItem(
                  value: grade,
                  child: Text(grade),
                );
              }).toList(),
        hint: Text("学年を選択"),
        value: _grade,
        onChanged: (value) {
          setState(() {
            _grade = value.toString();
          });
        });
  }

  // 選択状態を保持する変数
  String? _selectedFaculty; // 選択された学術院
  String? _selectedDepartment; // 選択された研究群/専攻
  String? _selectedCluster; // 選択された学群
  String? _selectedMajor; // 選択された学類

  // データ定義
  final Map<String, List<String>> facultiesAndDepartments = {
    "人文社会ビジネス科学学術院": ["人文社会科学研究群", "ビジネス科学研究群", "法曹専攻", "国際経営プロフェッショナル"],
    "理工情報生命学術院": ["数理物質科学研究群", "システム情報工学研究群", "生命地球科学研究群", "国際連携持続環境科学"],
    "人間総合科学学術院": ["人間総合科学研究群", "スポーツ国際開発学共同", "大学体育スポーツ高度化共同", "国際連携食料健康科学"],
    "グローバル教育院": ["グローバル教育院"],
  };

  final Map<String, List<String>> clustersAndMajors = {
    "情報学群": ["情報科学類", "情報メディア創成学類", "知識情報図書館学類"],
    "理工学群": [
      "数学類",
      "物理学類",
      "化学類",
      "応用理工学類",
      "工学システム学類",
      "社会工学類",
      "総合理工学位プログラム"
    ],
    "生命環境学群": ["生物学類", "地球学類", "生物資源学類"],
    "医学群": ["医学類", "看護学類", "医療科学類"],
    "体育専門学群": ["体育専門学群"],
    "芸術専門学群": ["芸術専門学群"],
    "人文・文化学群": ["人文学類", "比較文化学類", "日本語・日本文化学類"],
    "社会・国際学群": ["社会学類", "国際総合学類"],
    "総合学域群": ["総合学域群文系", "総合学域群第一類", "総合学域群第二類", "総合学域群第三類"],
    "人間学群": ["心理学類", "教育学類", "障害科学類"],
  };

  final List<String> faculties = [
    "人文社会ビジネス科学学術院",
    "理工情報生命学術院",
    "人間総合科学学術院",
    "グローバル教育院",
  ];

  final List<String> clusters = [
    "情報学群",
    "理工学群",
    "生命環境学群",
    "医学群",
    "体育専門学群",
    "芸術専門学群",
    "人文・文化学群",
    "社会・国際学群",
    "総合学域群",
    "人間学群",
  ];

  // 研究群/専攻ドロップダウン
  DropdownButton<String> dropDownDepartment() {
    return DropdownButton<String>(
      isExpanded: true,
      items: (facultiesAndDepartments[_selectedFaculty] ?? [])
          .map((department) => DropdownMenuItem(
                value: department,
                child: Text(department),
              ))
          .toList(),
      hint: Text("研究群/専攻を選択"),
      value: _selectedDepartment,
      onChanged: (value) {
        setState(() {
          _selectedDepartment = value;
        });
      },
    );
  }

  // 学術院選択ドロップダウン
  DropdownButton<String> dropDownFaculty() {
    return DropdownButton<String>(
      isExpanded: true,
      items: faculties
          .map((faculty) => DropdownMenuItem(
                value: faculty,
                child: Text(faculty),
              ))
          .toList(),
      hint: Text("学術院を選択"),
      value: _selectedFaculty,
      onChanged: (value) {
        setState(() {
          _selectedFaculty = value;
          _selectedDepartment = null; // 専攻選択をリセット
        });
      },
    );
  }

  // 学類選択ドロップダウン
  DropdownButton<String> dropDownMajor() {
    return DropdownButton<String>(
      isExpanded: true,
      items: (clustersAndMajors[_selectedCluster] ?? [])
          .map((major) => DropdownMenuItem(
                value: major,
                child: Text(major),
              ))
          .toList(),
      hint: Text("学類を選択"),
      value: _selectedMajor,
      onChanged: (value) {
        setState(() {
          _selectedMajor = value;
        });
      },
    );
  }

  // 学群選択ドロップダウン
  DropdownButton<String> dropDownCluster() {
    return DropdownButton<String>(
      isExpanded: true,
      items: clusters
          .map((cluster) => DropdownMenuItem(
                value: cluster,
                child: Text(cluster),
              ))
          .toList(),
      hint: Text("学群を選択"),
      value: _selectedCluster,
      onChanged: (value) {
        setState(() {
          _selectedCluster = value;
          _selectedMajor = null; // 学類選択をリセット
        });
      },
    );
  }

  Radio<RadioValue> radioButton(RadioValue radioValue) {
    return Radio<RadioValue>(
      value: radioValue,
      groupValue: _academicStage,
      onChanged: (RadioValue? value) {
        setState(() {
          _academicStage = value;
        });
      },
    );
  }
}
