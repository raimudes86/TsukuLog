import 'package:flutter/material.dart';
import 'package:tsukulog/models/user.dart';
import 'package:tsukulog/repositories/user_repository.dart';

class ShowPage extends StatefulWidget {
  final String uid; // ユーザーIDを受け取るプロパティ

  const ShowPage({super.key, required this.uid});

  @override
  State<ShowPage> createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  String nickname = '';
  int star = 0;
  String grade = '';
  String major = '';
  String futurePath = '';
  List<Map<String, dynamic>> careerHistories = [];
  List<Map<String, dynamic>> qualifications = [];
  List<Map<String, dynamic>> lessons = [];
  List<Map<String, dynamic>> portfolios = [];
  List<Map<String, dynamic>> clubs = [];

  final userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User user = await userRepository.fetchUser(widget.uid);

      setState(() {
        nickname = user.nickname;
        star = user.star;
        grade = user.grade;
        major = user.major;
        futurePath = user.futurePath;

        // Career Histories
        careerHistories = user.careerHistorys
            .map((history) => {
                  'title': history.title,
                  'category': history.category,
                  'startDate': history.startDate,
                  'span': history.span,
                  'comment': history.comment,
                })
            .toList();

        // Qualifications
        qualifications = user.qualifications
            .map((qualification) => {
                  'name': qualification.name,
                  'year': qualification.year,
                })
            .toList();

        // Lessons
        lessons = user.lessons
            .map((lesson) => {
                  'name': lesson.name,
                  'comment': lesson.comment,
                })
            .toList();

        // Portfolios
        portfolios = user.portfolios
            .map((portfolio) => {
                  'name': portfolio.name,
                  'comment': portfolio.comment,
                })
            .toList();

        // Clubs
        clubs = user.clubs
            .map((club) => {
                  'name': club.name,
                  'comment': club.comment,
                })
            .toList();
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        nickname = 'Error';
      });
    }
  }

  @override
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
                  Text('Name: $nickname', style: TextStyle(fontSize: 18)),
                  Text('Star: $star', style: TextStyle(fontSize: 18)),
                  Text('Grade: $grade', style: TextStyle(fontSize: 18)),
                  Text('Major: $major', style: TextStyle(fontSize: 18)),
                  Text('Future Path: $futurePath',
                      style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 16),

                  // Career History
                  if (careerHistories.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Career History:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        for (var history in careerHistories)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  Title: ${history['title']}'),
                              Text('  Category: ${history['category']}'),
                              Text('  Start Date: ${history['startDate']}'),
                              Text('  Span: ${history['span']}'),
                              Text('  Comment: ${history['comment']}'),
                            ],
                          ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Qualification
                  if (qualifications.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Qualification:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        for (var qualification in qualifications)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  Name: ${qualification['name']}'),
                              Text('  Year: ${qualification['year']}'),
                            ],
                          ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Lesson
                  if (lessons.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lesson:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        for (var lesson in lessons)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  Name: ${lesson['name']}'),
                              Text('  Comment: ${lesson['comment']}'),
                            ],
                          ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Portfolio
                  if (portfolios.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Portfolio:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        for (var portfolio in portfolios)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  Name: ${portfolio['name']}'),
                              Text('  Comment: ${portfolio['comment']}'),
                            ],
                          ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Club
                  if (clubs.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Club:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        for (var club in clubs)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('  Name: ${club['name']}'),
                              Text('  Comment: ${club['comment']}'),
                            ],
                          ),
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
