import 'package:flutter/material.dart';
import 'package:tsukulog/models/user.dart';
import 'package:tsukulog/repositories/user_repository.dart';

class ShowPage extends StatefulWidget {
  final String uid; // ユーザーIDを受け取るプロパティ

  const ShowPage({Key? key, required this.uid}) : super(key: key);

  @override
  _ShowPageState createState() => _ShowPageState(); // Stateクラスを作成
}

class _ShowPageState extends State<ShowPage> {
  // nullableにする必要ある？？
  User? userData;
  final userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User user = await userRepository.fetchUser(widget.uid); // 非同期処理
      setState(() {
        userData = user;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        userData = null; // エラー時またはデータなし
      });
    }
    // print('${userData?.lessons[0].name}'); 情報取得できてました
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Show Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 子要素を中央に配置
          children: [
            const Text(
              'This is the Show Page',
            ),
            Text('UID: ${widget.uid}'), // ShowPageから渡されたUIDを表示
            Expanded(
              child: ListView(
                children: [
                  // メイン情報
                  Text('Name: ${userData?.nickname}',
                      style: TextStyle(fontSize: 18)),
                  Text('Star: ${userData?.star}',
                      style: TextStyle(fontSize: 18)),
                  Text('Grade: ${userData?.grade}',
                      style: TextStyle(fontSize: 18)),
                  Text('Major: ${userData?.major}',
                      style: TextStyle(fontSize: 18)),
                  Text('Future Path: ${userData?.futurePath}',
                      style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 16),

                  // Career History
                  if (userData != null && userData!.careerHistorys.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Career History:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('  Title: ${userData?.careerHistorys[0].title}'),
                        Text(
                            '  Category: ${userData?.careerHistorys[0].category}'),
                        Text(
                            '  Start Date: ${userData?.careerHistorys[0].startDate}'),
                        Text('  Span: ${userData?.careerHistorys[0].span}'),
                        Text(
                            '  Comment: ${userData?.careerHistorys[0].comment}'),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Qualification
                  if (userData != null && userData!.qualifications.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Qualification:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('  Name: ${userData?.qualifications[0].name}'),
                        Text('  Year: ${userData?.qualifications[0].year}'),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Lesson
                  if (userData != null && userData!.lessons.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lesson:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('  Name: ${userData?.lessons[0].name}'),
                        Text('  Comment: ${userData?.lessons[0].comment}'),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Portfolio
                  if (userData != null && userData!.portfolios.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Portfolio:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('  Name: ${userData?.portfolios[0].name}'),
                        Text('  Comment: ${userData?.portfolios[0].comment}'),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Club
                  if (userData != null && userData!.clubs.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Club:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('  Name: ${userData?.clubs[0].name}'),
                        Text('  Comment: ${userData?.clubs[0].comment}'),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
