import 'package:tsukulog/models/career_history.dart';
import 'package:tsukulog/models/club.dart';
import 'package:tsukulog/models/lesson.dart';
import 'package:tsukulog/models/portfolio.dart';
import 'package:tsukulog/models/qualification.dart';

//このユーザーはサブコレクションのデータまで全てリストで保持している
class User {
  final String id;
  final String nickname;
  final int star;
  final String grade;
  final String major;
  final String futurePath;
  final String turningPointId;
  final List<CareerHistory> careerHistorys;
  final List<Qualification> qualifications;
  final List<Lesson> lessons;
  final List<Club> clubs;
  final List<PortFolio> portfolios;

  User({
    required this.id,
    required this.nickname,
    required this.star,
    required this.grade,
    required this.major,
    required this.futurePath,
    required this.turningPointId,
    required this.careerHistorys,
    required this.qualifications,
    required this.lessons,
    required this.clubs,
    required this.portfolios,
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
  ) {
    return User(
      id: id,
      nickname: userMap['nickname'] ?? '',
      star: userMap['star'] ?? 0,
      grade: userMap['grade'] ?? '',
      major: userMap['major'] ?? '',
      futurePath: userMap['future_path'] ?? '',
      turningPointId: userMap['turning_point_id'] ?? '',
      careerHistorys:
          careerData.map((data) => CareerHistory.fromMap(data)).toList(),
      qualifications:
          qualificationData.map((data) => Qualification.fromMap(data)).toList(),
      lessons: lessonData.map((data) => Lesson.fromMap(data)).toList(),
      portfolios: portfolioData.map((data) => PortFolio.fromMap(data)).toList(),
      clubs: clubData.map((data) => Club.fromMap(data)).toList(),
    );
  }
}
