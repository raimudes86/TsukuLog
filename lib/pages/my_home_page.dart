import 'package:cloud_firestore/cloud_firestore.dart';
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
  User? _user;
  //UserREpositoryを初期化
  final userRepository = UserRepository();

  Future<void> _loadUser() async {
    try {
      User user = await userRepository.fetchUser("AWSshw5P8MNmpa5Qk3an");
      setState(() {
        _user = user;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _user = null; //ユーザが見つからない場合
      });
    }
    //ちゃんとサブコレクションの中身も取得できてるっぽい
    //print('${_user?.lessons[0].name}');
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50), // 横幅200、高さ50を指定
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowPage(uid: "AWSshw5P8MNmpa5Qk3an")),
                  );
                },
                child: Text("Show ビットくん")),
            const SizedBox(height: 16),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50), // 横幅200、高さ50を指定
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowPage(uid: "WBqBABwIlO2yiiWn5ywV")),
                  );
                },
                child: Text("Show 205")),
            const SizedBox(height: 16),
            // Expanded(
            //   child: ListView(
            //     children: [
            //       // メイン情報
            //       Text('Name: ${_user?.nickname}',
            //           style: TextStyle(fontSize: 18)),
            //       Text('Star: ${_user?.star}', style: TextStyle(fontSize: 18)),
            //       Text('Grade: ${_user?.grade}',
            //           style: TextStyle(fontSize: 18)),
            //       Text('Major: ${_user?.major}',
            //           style: TextStyle(fontSize: 18)),
            //       Text('Future Path: ${_user?.futurePath}',
            //           style: TextStyle(fontSize: 18)),

            //       const SizedBox(height: 16),

            //       // Career History
            //       if (_user != null && _user!.careerHistorys.isNotEmpty)
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text('Career History:',
            //                 style: TextStyle(
            //                     fontSize: 20, fontWeight: FontWeight.bold)),
            //             Text('  Title: ${_user?.careerHistorys[0].title}'),
            //             Text(
            //                 '  Category: ${_user?.careerHistorys[0].category}'),
            //             Text(
            //                 '  Start Date: ${_user?.careerHistorys[0].startDate}'),
            //             Text('  Span: ${_user?.careerHistorys[0].span}'),
            //             Text('  Comment: ${_user?.careerHistorys[0].comment}'),
            //           ],
            //         ),

            //       const SizedBox(height: 16),

            //       // Qualification
            //       if (_user != null && _user!.qualifications.isNotEmpty)
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text('Qualification:',
            //                 style: TextStyle(
            //                     fontSize: 20, fontWeight: FontWeight.bold)),
            //             Text('  Name: ${_user?.qualifications[0].name}'),
            //             Text('  Year: ${_user?.qualifications[0].year}'),
            //           ],
            //         ),

            //       const SizedBox(height: 16),

            //       // Lesson
            //       if (_user != null && _user!.lessons.isNotEmpty)
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text('Lesson:',
            //                 style: TextStyle(
            //                     fontSize: 20, fontWeight: FontWeight.bold)),
            //             Text('  Name: ${_user?.lessons[0].name}'),
            //             Text('  Comment: ${_user?.lessons[0].comment}'),
            //           ],
            //         ),

            //       const SizedBox(height: 16),

            //       // Portfolio
            //       if (_user != null && _user!.portfolios.isNotEmpty)
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text('Portfolio:',
            //                 style: TextStyle(
            //                     fontSize: 20, fontWeight: FontWeight.bold)),
            //             Text('  Name: ${_user?.portfolios[0].name}'),
            //             Text('  Comment: ${_user?.portfolios[0].comment}'),
            //           ],
            //         ),

            //       const SizedBox(height: 16),

            //       // Club
            //       if (_user != null && _user!.clubs.isNotEmpty)
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text('Club:',
            //                 style: TextStyle(
            //                     fontSize: 20, fontWeight: FontWeight.bold)),
            //             Text('  Name: ${_user?.clubs[0].name}'),
            //             Text('  Comment: ${_user?.clubs[0].comment}'),
            //           ],
            //         ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadUser, //fetchUserを非同期で呼び出す
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
