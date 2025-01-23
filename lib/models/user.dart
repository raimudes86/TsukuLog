import 'package:tsukulog/models/career_history.dart';
import 'package:tsukulog/models/club.dart';
import 'package:tsukulog/models/lesson.dart';
import 'package:tsukulog/models/portfolio.dart';
import 'package:tsukulog/models/qualification.dart';
import 'package:tsukulog/models/suggest.dart';

//このユーザーはサブコレクションのデータまで全てリストで保持している
class User {
  final String id;
  final String nickname;
  final int like;
  final String grade;
  final String major;
  final String futurePath;
  final int selectedIcon;
  final String bestCareerId;
  final List<String> tags;
  final List<String> companies;
  final List<CareerHistory> careerHistories;
  final List<Qualification> qualifications;
  final List<Lesson> lessons;
  final List<Club> clubs;
  final List<PortFolio> portfolios;
  final List<Suggest> suggests;

  User({
    required this.id,
    required this.nickname,
    required this.like,
    required this.grade,
    required this.major,
    required this.futurePath,
    required this.selectedIcon,
    required this.bestCareerId,
    required this.tags,
    required this.companies,
    required this.careerHistories,
    required this.qualifications,
    required this.lessons,
    required this.clubs,
    required this.portfolios,
    required this.suggests,
  });

  //サブコレクションたちはfetchしてきた後に
  factory User.fromFirestore(
    String id,
    Map<String, dynamic> userMap,
    List<Map<String, dynamic>> careerData,
    List<Map<String, dynamic>> qualificationData,
    List<Map<String, dynamic>> lessonData,
    List<Map<String, dynamic>> portfolioData,
    List<Map<String, dynamic>> clubData,
    List<Map<String, dynamic>> suggestData,
  ) {
    return User(
      id: id,
      nickname: userMap['nickname'] ?? '未設定',
      like: userMap['like'] ?? 0,
      grade: userMap['grade'] ?? '未設定',
      major: userMap['major'] ?? '未設定',
      futurePath: userMap['future_path'] ?? '未設定',
      selectedIcon: userMap['selected_icon'] ?? 0,
      bestCareerId: userMap['best_career_id'] ?? '',
      tags: List<String>.from(userMap['tags'] ?? []),
      companies: List<String>.from(userMap['companies'] ?? []),
      careerHistories:
          careerData.map((data) => CareerHistory.fromMap(data)).toList(),
      qualifications:
          qualificationData.map((data) => Qualification.fromMap(data)).toList(),
      lessons: lessonData.map((data) => Lesson.fromMap(data)).toList(),
      portfolios: portfolioData.map((data) => PortFolio.fromMap(data)).toList(),
      clubs: clubData.map((data) => Club.fromMap(data)).toList(),
      suggests: suggestData.map((data) => Suggest.fromMap(data)).toList(),
    );
  }

  factory User.fromFirestoreForSmall(
    String id,
    Map<String, dynamic> userMap,
  ) {
    return User(
      id: id,
      nickname: userMap['nickname'] ?? '未設定',
      like: userMap['like'] ?? 0,
      grade: userMap['grade'] ?? '未設定',
      major: userMap['major'] ?? '未設定',
      futurePath: userMap['future_path'] ?? '未設定',
      selectedIcon: userMap['selected_icon'] ?? 0,
      bestCareerId: userMap['best_career_id'] ?? '',
      tags: List<String>.from(userMap['tags'] ?? []),
      companies: List<String>.from(userMap['companies'] ?? []),
      careerHistories: [],
      qualifications: [],
      lessons: [],
      portfolios: [],
      clubs: [],
      suggests: [],
    );
  }
}
