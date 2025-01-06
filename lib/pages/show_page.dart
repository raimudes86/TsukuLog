import 'package:flutter/material.dart';
import 'package:tsukulog/components/best_career_card.dart';
import 'package:tsukulog/components/career_history_card.dart';
import 'package:tsukulog/components/career_detail_card.dart';
import 'package:tsukulog/components/club_card.dart';
import 'package:tsukulog/components/portfolio_card.dart';
import 'package:tsukulog/components/profile_card.dart';
import 'package:tsukulog/components/qualification_card.dart';
import 'package:tsukulog/components/lesson_card.dart';
import 'package:tsukulog/models/career_history.dart';
import 'package:tsukulog/models/club.dart';
import 'package:tsukulog/models/lesson.dart';
import 'package:tsukulog/models/portfolio.dart';
import 'package:tsukulog/models/qualification.dart';
import 'package:tsukulog/models/suggest.dart';
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
  // String grade = '';
  //ここの変数を(startGradeとstartMonth)変えたので付随して変更する箇所を変更してください
  //startGradeにはB1などの文字列が入り、startMonthには1、2などのintが入っているので表示を変更してください
  String startGrade = '';
  int startMonth = 0;
  String major = '';
  String futurePath = '';
  CareerHistory? bestCareer;
  List<CareerHistory> careerHistories = [];
  List<Qualification> qualifications = [];
  List<Lesson> lessons = [];
  List<PortFolio> portfolios = [];
  List<Club> clubs = [];
  List<Suggest> suggests = [];

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
        suggests = user.suggests;
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // デバッグ用
            // const Text(
            //   'This is the Show Page',
            // ),
            // Text('UID: ${widget.uid}'),
            Expanded(
              child: ListView(
                children: [
                  // Profile
                  ProfileCard(
                    nickname: nickname,
                    grade: grade,
                    major: major,
                    futurePath: futurePath,
                    star: star,
                    // imageUrl: '',
                  ),

                  // Best Career
                  if (bestCareer != null)
                    BestCareerCard(
                      title: bestCareer!.title,
                      category: bestCareer!.category,
                      startDate: bestCareer!.startDate,
                      span: bestCareer!.span,
                      difficultLevel: bestCareer!.difficultLevel,
                      recommendLevel: bestCareer!.recommendLevel,
                      reason: bestCareer!.reason,
                      comment: bestCareer!.comment,
                    ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //ここのRowのconstを一旦消しました
                      Row(
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
                      for (var suggest in suggests)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0), // 上下に余白を追加
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${suggest.name}',
                                style: const TextStyle(
                                  fontSize: 16.0, // フォントサイズ
                                  fontWeight: FontWeight.bold, // 太字
                                ),
                              ),
                              const SizedBox(height: 4.0), // 行間を追加
                              Text(
                                'Comment: ${suggest.comment}',
                                style: const TextStyle(
                                  fontSize: 14.0, // フォントサイズ
                                  color: Colors.grey, // コメントを目立たせない色
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),
                    ],
                  ),

                  // Career History
                  if (careerHistories.isNotEmpty)
                    CareerHistoryCard(careerHistories: careerHistories),

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
    );
  }
}
