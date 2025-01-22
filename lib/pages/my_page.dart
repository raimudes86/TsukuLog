import 'package:flutter/material.dart';
import 'package:tsukulog/components/best_career_card.dart';
import 'package:tsukulog/components/career_history_card.dart';
import 'package:tsukulog/components/club_card.dart';
import 'package:tsukulog/components/forms/career_history_form.dart';
import 'package:tsukulog/components/forms/club_form.dart';
import 'package:tsukulog/components/forms/lesson_form.dart';
import 'package:tsukulog/components/forms/portfolio_form.dart';
import 'package:tsukulog/components/forms/qualification_form.dart';
import 'package:tsukulog/components/forms/suggest_form.dart';
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
import 'package:tsukulog/repositories/user_repository.dart';

class MyPage extends StatefulWidget {
  final String uid; // ユーザーIDを受け取るプロパティ

  const MyPage({super.key, required this.uid});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool isLoading = true;
  String? selectedItem;

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

  void showFormModal(BuildContext context, String selectedItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView(
            children: [
              Text(
                selectedItem,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              if (selectedItem == 'これだけはやっておけ！！')
                SuggestForm(
                  uid: widget.uid,
                  suggest: null,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == '経歴')
                CareerHistoryForm(
                  uid: widget.uid,
                  bestCareerId: bestCareerId,
                  careerHistory: null,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == '資格・受賞歴')
                QualificationForm(
                  uid: widget.uid,
                  qualification: null,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == 'おすすめの授業')
                LessonForm(
                  uid: widget.uid,
                  lesson: null,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == '制作物・成果物')
                PortfolioForm(
                  uid: widget.uid,
                  portfolio: null,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == 'コミュニティ')
                ClubForm(
                  uid: widget.uid,
                  club: null,
                  onSaveComplete: fetchUserData,
                ),
            ],
          ),
        );
      },
    );
  }

  void showEditFormModal(
      BuildContext context, String selectedItem, dynamic item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView(
            children: [
              Text(
                selectedItem,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              if (selectedItem == 'これだけはやっておけ！！')
                SuggestForm(
                  uid: widget.uid,
                  suggest: item,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == '経歴')
                CareerHistoryForm(
                  uid: widget.uid,
                  bestCareerId: bestCareerId,
                  careerHistory: item,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == '資格・受賞歴')
                QualificationForm(
                  uid: widget.uid,
                  qualification: item,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == 'おすすめの授業')
                LessonForm(
                  uid: widget.uid,
                  lesson: item,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == '制作物・成果物')
                PortfolioForm(
                  uid: widget.uid,
                  portfolio: item,
                  onSaveComplete: fetchUserData,
                ),
              if (selectedItem == 'コミュニティ')
                ClubForm(
                  uid: widget.uid,
                  club: item,
                  onSaveComplete: fetchUserData,
                ),
            ],
          ),
        );
      },
    );
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
                  if (suggests.isNotEmpty)
                    SuggestCard(
                      suggests: suggests,
                      isMyPage: true,
                      onEditButtonPressed: showEditFormModal,
                    ),

                  // Career History
                  if (careerHistories.isNotEmpty)
                    CareerHistoryCard(
                        nickname: nickname,
                        bestCareerId: bestCareerId,
                        careerHistories: careerHistories),

                  // Qualification
                  if (qualifications.isNotEmpty)
                    QualificationCard(
                      qualifications: qualifications,
                      isMyPage: true,
                      onEditButtonPressed: showEditFormModal,
                    ),

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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '項目を追加',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.lightbulb),
                      title: Text('これだけはやっておけ！！'),
                      onTap: () {
                        setState(() {
                          selectedItem = 'これだけはやっておけ！！';
                        });
                        Navigator.pop(context);
                        showFormModal(context, selectedItem!);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.double_arrow),
                      title: Text('経歴'),
                      onTap: () {
                        setState(() {
                          selectedItem = '経歴';
                        });
                        Navigator.pop(context);
                        showFormModal(context, selectedItem!);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.workspace_premium),
                      title: Text('資格・受賞歴'),
                      onTap: () {
                        setState(() {
                          selectedItem = '資格・受賞歴';
                        });
                        Navigator.pop(context);
                        showFormModal(context, selectedItem!);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.menu_book),
                      title: Text('おすすめの授業'),
                      onTap: () {
                        setState(() {
                          selectedItem = 'おすすめの授業';
                        });
                        Navigator.pop(context);
                        showFormModal(context, selectedItem!);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.build),
                      title: Text('制作物・成果物'),
                      onTap: () {
                        setState(() {
                          selectedItem = '制作物・成果物';
                        });
                        Navigator.pop(context);
                        showFormModal(context, selectedItem!);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.groups),
                      title: Text('コミュニティ'),
                      onTap: () {
                        setState(() {
                          selectedItem = 'コミュニティ';
                        });
                        Navigator.pop(context);
                        showFormModal(context, selectedItem!);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Colors.cyan[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.mode, color: Colors.white),
      ),
    );
  }
}
