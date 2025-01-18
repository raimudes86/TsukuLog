import 'package:flutter/material.dart';
import 'package:tsukulog/components/best_career_card.dart';
import 'package:tsukulog/components/career_history_card.dart';
import 'package:tsukulog/components/club_card.dart';
import 'package:tsukulog/components/lesson_card.dart';
import 'package:tsukulog/components/portfolio_card.dart';
import 'package:tsukulog/components/qualification_card.dart';
import 'package:tsukulog/components/suggest_card.dart';
import 'dart:developer' as developer;
import 'package:tsukulog/models/career_history.dart';
import 'package:tsukulog/models/club.dart';
import 'package:tsukulog/models/lesson.dart';
import 'package:tsukulog/models/portfolio.dart';
import 'package:tsukulog/models/qualification.dart';
import 'package:tsukulog/models/suggest.dart';
import 'package:tsukulog/models/user.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.currentUser});
  final User? currentUser;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isLoading = true;

  String nickname = '';
  int like = 0;
  String grade = '';
  String major = '';
  String futurePath = '';
  int selecetedIcon = 1;
  String bestCareerId = '';
  List<CareerHistory> careerHistories = [];
  List<Qualification> qualifications = [];
  List<Lesson> lessons = [];
  List<PortFolio> portfolios = [];
  List<Club> clubs = [];
  List<Suggest> suggests = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User user = widget.currentUser!;

      setState(() {
        nickname = user.nickname;
        like = user.like;
        grade = user.grade;
        major = user.major;
        futurePath = user.futurePath;
        selecetedIcon = user.selectedIcon;
        bestCareerId = user.bestCareerId;
        careerHistories = user.careerHistories;
        qualifications = user.qualifications;
        lessons = user.lessons;
        portfolios = user.portfolios;
        clubs = user.clubs;
        suggests = user.suggests;

        isLoading = false; // ローディング終了
      });
    } catch (e) {
      developer.log('Error: $e');
      setState(() {
        nickname = 'Error';
        isLoading = false; // ローディング終了
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ユーザーのベストキャリアを取得
    CareerHistory? bestCareer = careerHistories.firstWhere(
      (career) => career.id == bestCareerId,
      orElse: () => CareerHistory(
        id: '', // デフォルトの ID
        title: 'No Title',
        category: 'No Category',
        startGrade: '',
        startMonth: 0,
        span: '',
        difficultLevel: 0,
        recommendLevel: 0,
        reason: 'No Reason',
        comment: 'No Comment',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('マイページ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Profile
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF9424E3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 星アイコンとスター数
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '参考になった $like',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nickname,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // 学年と専攻
                                  Text(
                                    '$grade  $major',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // 進路情報
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 230, 230, 230),
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
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(
                                  'assets/images/icon$selecetedIcon.webp'),
                              child: selecetedIcon < 1 || selecetedIcon > 5
                                  ? Text(
                                      nickname.isNotEmpty
                                          ? nickname[0] // 名前のイニシャルを表示
                                          : '仮',
                                      style: const TextStyle(
                                        fontSize: 48.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Best Career
                  if (bestCareerId.isNotEmpty)
                    BestCareerCard(
                      bestCareer: bestCareer,
                    ),

                  // Suggest
                  if (suggests.isNotEmpty) SuggestCard(suggests: suggests),

                  // Career History
                  if (careerHistories.isNotEmpty)
                    CareerHistoryCard(
                        nickname: nickname,
                        bestCareerId: bestCareerId,
                        careerHistories: careerHistories),

                  // Qualification
                  if (qualifications.isNotEmpty)
                    QualificationCard(qualifications: qualifications),

                  // Lesson
                  if (lessons.isNotEmpty) LessonCard(lessons: lessons),

                  // Portfolio
                  if (portfolios.isNotEmpty)
                    PortfolioCard(portfolios: portfolios),

                  // Club
                  if (clubs.isNotEmpty) ClubCard(clubs: clubs),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.cyan[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.mode, color: Colors.white),
      ),
    );
  }
}
