import 'package:flutter/material.dart';
import 'package:tsukulog/components/best_carrer_card.dart';
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF9424E3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 星アイコンとスター数
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.star, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '参考になった $star',
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // 名前
                        Text(
                          nickname,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // 学年と専攻
                        Text(
                          '$grade  $major',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // 進路情報
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 230, 230),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '  $futurePath  ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                
                  const SizedBox(height: 16),

                  if (bestCareer != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.double_arrow, color: Color(0xFF252525)),
                            SizedBox(width: 4),
                            Text(
                              'ベストキャリア',
                              style: TextStyle(
                                color: Color(0xFF252525),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                ),
                            ),
                          ],
                        ),
                        Center(
                          child: BestCarrerCard(
                            title: bestCareer!.title,
                            category: bestCareer!.category,
                            startDate: bestCareer!.startDate,
                            span: bestCareer!.span,
                            difficultLevel: bestCareer!.difficultLevel,
                            recommendLevel: bestCareer!.recommendLevel,
                            reason: bestCareer!.reason,
                            comment: bestCareer!.comment,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Career History
                  if (careerHistories.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            Icon(Icons.double_arrow, color: Color(0xFF252525)),
                            SizedBox(width: 4),
                            Text(
                              'これだけはやっておけ！！！',
                              style: TextStyle(
                                color: Color(0xFF252525),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                ),
                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
