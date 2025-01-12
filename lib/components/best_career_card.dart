import 'package:flutter/material.dart';
import 'package:tsukulog/models/career_history.dart';
import 'package:tsukulog/components/career_icon.dart';


class BestCareerCard extends StatelessWidget {
  final String bestCareerId;
  final List<CareerHistory> careerHistories;

  const BestCareerCard({
    super.key,
    required this.bestCareerId,
    required this.careerHistories,
  });

  @override
  Widget build(BuildContext context) {
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

    // 存在しない場合は空のウィジェットを返す
    if (bestCareer.id.isEmpty) {
      return const SizedBox.shrink(); // 空のウィジェットを返す
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Icon(Icons.double_arrow, color: Color(0xFF252525)),
            SizedBox(width: 4),
            Text(
              'マイベストキャリア',
              style: TextStyle(
                color: Color(0xFF252525),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                ),
            ),
          ],
        ),
        Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 学年/月とアイコン
                  Row(
                    children: [
                      // アイコン
                    CareerIcon(categoryName: bestCareer.category, size: 60),
                      const SizedBox(width: 16),
                      // 学年/月
                      Text(
                        '${bestCareer.startGrade}の${bestCareer.startMonth}月から${bestCareer.span}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFF252525),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 会社名とインターン種類
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bestCareer.title,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFF252525),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          bestCareer.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 評価セクション（ハードル＆おすすめ度）
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ハードル評価
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ハードル',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF252525),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStarRating(bestCareer.difficultLevel, 30.0),
                        ],
                      ),
                      // おすすめ度評価
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'おすすめ度',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF252525),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStarRating(bestCareer.recommendLevel, 30.0),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 理由
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, color: Color(0xFF252525), size: 24),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '入ったきっかけ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF252525),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bestCareer.reason,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF252525),
                      ),
                  ),
                  const SizedBox(height: 16),

                  // コメント
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.comment, color: Color(0xFF252525), size: 24),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'コメント',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF252525),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bestCareer.comment,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF252525),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    ); 
  }

  // 星評価ウィジェット
  Widget _buildStarRating(int stars, double starSize) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: starSize,
        );
      }),
    );
  }
}
