import 'package:flutter/material.dart';

class BestCarrerCard extends StatelessWidget {
  final String title;
  final String category;
  final String startDate;
  final String span;
  final int difficultLevel;
  final int recommendLevel;
  final String reason;
  final String comment;

  const BestCarrerCard({
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
    return Card(
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
                    color: Colors.grey[400],
                  ),
                  child: const Center(
                    child: Text(
                      '*',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 学年/月
                Text(
                  '$startDate  $span',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF252525),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 会社名とインターン種類
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF252525),
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            const SizedBox(height: 16),

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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    _buildStarRating(recommendLevel),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // レビューコメント
            Text(
              reason,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF252525),
                ),
            ),
          ],
        ),
      ),
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
