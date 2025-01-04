import 'package:flutter/material.dart';
import 'package:tsukulog/models/career_history.dart';
import 'package:tsukulog/models/club.dart';
import 'package:tsukulog/models/lesson.dart';
import 'package:tsukulog/models/portfolio.dart';
import 'package:tsukulog/models/qualification.dart';
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
  CareerHistory? bestCareer;
  List<CareerHistory> careerHistories = [];
  List<Qualification> qualifications = [];
  List<Lesson> lessons = [];
  List<PortFolio> portfolios = [];
  List<Club> clubs = [];

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
        bestCareer = user.bestCareer;
        careerHistories = user.careerHistorys;
        qualifications = user.qualifications;
        lessons = user.lessons;
        portfolios = user.portfolios;
        clubs = user.clubs;
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

                  if (bestCareer != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Best Career:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('  Title: ${bestCareer?.title}'),
                            Text('  Category: ${bestCareer?.category}'),
                            Text('  Start Date: ${bestCareer?.startDate}'),
                            Text('  Span: ${bestCareer?.span}'),
                            Text('  Comment: ${bestCareer?.comment}'),
                          ],
                        ),
                      ],
                    ),

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
                              Text('  Title: ${history.title}'),
                              Text('  Category: ${history.category}'),
                              Text('  Start Date: ${history.startDate}'),
                              Text('  Span: ${history.span}'),
                              Text('  Comment: ${history.comment}'),
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
                              Text('  Name: ${qualification.name}'),
                              Text('  Year: ${qualification.year}'),
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
                              Text('  Name: ${lesson.name}'),
                              Text('  Comment: ${lesson.comment}'),
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
                              Text('  Name: ${portfolio.name}'),
                              Text('  Comment: ${portfolio.comment}'),
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
                              Text('  Name: ${club.name}'),
                              Text('  Comment: ${club.comment}'),
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
