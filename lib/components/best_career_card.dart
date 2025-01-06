import 'package:flutter/material.dart';

class BestCareerCard extends StatelessWidget {
  final String title;
  final String category;
  final String startDate;
  final String span;
  final int difficultLevel;
  final int recommendLevel;
  final String reason;
  final String comment;

  const BestCareerCard({
    Key? key,
    required this.title,
    required this.category,
    required this.startDate,
    required this.span,
    required this.difficultLevel,
    required this.recommendLevel,
    required this.reason,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0XFF49484B),
                        ),
                        child: const Center(
                          child: Text(
                            '*',
                            style: TextStyle(
                              fontSize: 44,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 学年/月
                      Text(
                        '$startDate から $span',
                        style: TextStyle(
                          fontSize: 14,
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
                        title,
                        style: const TextStyle(
                          fontSize: 20,
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
                          category,
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
                            style: TextStyle(fontSize: 14),
                          ),
                          _buildStarRating(difficultLevel),
                        ],
                      ),
                      // おすすめ度評価
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'おすすめ度',
                            style: TextStyle(fontSize: 14),
                          ),
                          _buildStarRating(recommendLevel),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 理由
                  const Text(
                    '入ったきっかけ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF252525),
                      fontWeight: FontWeight.bold,
                      ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF252525),
                      ),
                  ),
                  const SizedBox(height: 16),

                  // コメント
                  const Text(
                    'コメント',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF252525),
                      fontWeight: FontWeight.bold,
                      ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment,
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
  Widget _buildStarRating(int stars) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
