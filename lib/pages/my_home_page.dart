import 'package:flutter/material.dart';
import 'package:tsukulog/pages/show_page.dart';
import 'package:tsukulog/components/user_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            UserButton(
              label: "ドミニカ共和国",
              uid: "qGOCYiLS8tEb9DDwSzf9",
            ),
            UserButton(
              label: "ビットくん",
              uid: "AWSshw5P8MNmpa5Qk3an",
            ),
            UserButton(
              label: "205",
              uid: "WBqBABwIlO2yiiWn5ywV",
            ),
            UserButton(
              label: "ひつじ",
              uid: "HZ0c1aD7Q2Q3nGIWxvvd",
            ),
            UserButton(
              label: "U",
              uid: "Rhxpp8kvJXw4FNCT7idj",
            ),
          ],
        ),
      ),
    );
  }
}
