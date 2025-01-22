import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:tsukulog/components/best_career_card.dart';
import 'package:tsukulog/components/career_history_card.dart';
import 'package:tsukulog/components/suggest_card.dart';
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
        title: const Text('プロフィール'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Profile
                  ProfileCard(
                    userId: widget.uid,
                    nickname: nickname,
                    grade: grade,
                    major: major,
                    futurePath: futurePath,
                    initialLike: like,
                    selectedIcon: selecetedIcon,
                  ),

                  // Best Career
                  if (bestCareerId.isNotEmpty)
                    BestCareerCard(
                      bestCareer: bestCareer,
                    ),

                  // Suggest
                  if (suggests.isNotEmpty)
                    SuggestCard(
                      suggests: suggests,
                      isMyPage: false,
                      onEditButtonPressed: () {},
                    ),

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
    );
  }
}
