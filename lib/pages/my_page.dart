import 'package:flutter/material.dart';
import 'package:tsukulog/models/user.dart';
import 'package:tsukulog/pages/my_home_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.currentUser});
  final User? currentUser;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentUser!.nickname),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        title: "つくログ",
                        isLoggedin: true,
                      )),
              (route) => false,
            );
          },
        ),
      ),
      body: const Center(
        child: Text('マイページ内容'),
      ),
    );
  }
}
