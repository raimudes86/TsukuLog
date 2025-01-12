import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tsukulog/pages/my_home_page.dart';
import 'package:tsukulog/pages/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
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
  //発生したエラーメッセージを格納する変数
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: Padding(
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
                decoration: const InputDecoration(labelText: 'メールアドレス'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
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
                        print("新規登録成功: ${_auth.currentUser!.uid}");
                      }
                      //firestoreにユーザー情報を保存
                      await _firestore.doc(_auth.currentUser!.uid).set({
                        'nickname': '未設定',
                        'star': 0, // 初期値
                        'grade': '未設定',
                        'major': '未設定',
                        'future_path': '未設定',
                        'best_career_id': '未設定',
                        'tags': [],
                        'companies': [],
                        'created_at': FieldValue.serverTimestamp(),
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _errorMessage = e.message!;
                      });
                    }
                  }
                  //非同期処理中に現在のウィジェットが破棄されるとcontextを使用した操作でエラー
                  //mountedプロパティでウィジェットが破棄されていないか確認をしてから画面遷移
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title:'つくログ'),
                      ),
                    );
                  }
                },
                child: const Text('新規登録'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
