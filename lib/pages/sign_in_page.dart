import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tsukulog/pages/my_home_page.dart';
import 'package:tsukulog/pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  //このUserはfirebaseAuthのやつだから、うちのモデルとは関係ない
  User? user;

  String _email = '';
  String _password = '';
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログイン'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'メールアドレスの形式が正しくありません';
                  }
                  return null;
                },
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
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      //このUserはfirebaseAuthのやつだから、うちのモデルとは関係ない
                      user = (await _auth.signInWithEmailAndPassword(
                              email: _email, password: _password))
                          .user;
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        _errorMessage = "パスワードまたはメールアドレスが正しくありません。";
                      } else if (e.code == 'wrong-password') {
                        _errorMessage = "パスワードまたはメールアドレスが正しくありません。";
                        //見直し必要
                      } else {
                        setState(() {
                          _errorMessage = "パスワードまたはメールアドレスが正しくありません。";
                        });
                      }
                    }
                  }
                  //非同期処理中に現在のウィジェットが破棄されるとcontextを使用した操作でエラー
                  //mountedプロパティでウィジェットが破棄されていないか確認をしてから画面遷移
                  if (mounted && user != null) {
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'つくログ'),
                      ),
                    );
                  }
                },
                child: const Text('ログイン'),
              ),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text('新規登録はこちらから')),
            ],
          ),
        ),
      ),
    );
  }
}
