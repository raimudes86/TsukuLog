import 'package:flutter/material.dart';
import 'package:tsukulog/components/career_icon.dart';
import 'package:tsukulog/models/career_history.dart';

class CareerDetailCard extends StatefulWidget {
  final CareerHistory career;
  final bool isBestCareer;
  final bool isMyPage;
  final Function onEditButtonPressed;

  const CareerDetailCard({
    super.key,
    required this.career,
    required this.isBestCareer,
    required this.isMyPage,
    required this.onEditButtonPressed,
  });

  @override
  State<CareerDetailCard> createState() => _CareerDetailCardState();
}

class _CareerDetailCardState extends State<CareerDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左側のアイコン
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CareerIcon(categoryName: widget.career.category),
                  ],
                ),
                const SizedBox(width: 10),
                // タイトルとカテゴリ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.career.title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0XFF252525),
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
                          widget.career.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.isBestCareer)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.military_tech,
                        color: Color(0xFFFFD700),
                        size: 45,
                      ),
                      const Text(
                        'ベスト',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'キャリア',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // ハードルとおすすめ度の星評価
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.career.startGrade}/${widget.career.startMonth}月から',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF252525),
                      ),
                    ),
                    Text(
                      widget.career.span,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF252525),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '個人的ハードル',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF252525),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(widget.career.difficultLevel),
                  ],
                ),
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
                    const SizedBox(height: 4),
                    _buildStarRating(widget.career.recommendLevel),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 理由
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: Color(0xFF252525), size: 24),
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
              widget.career.reason,
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
              widget.career.comment,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF252525),
              ),
            ),
            if (widget.isMyPage)
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan[400], // 背景色
                    foregroundColor: Colors.white, // 文字色
                    padding: const EdgeInsets.symmetric(
                      vertical: 4, // 上下の余白
                      horizontal: 4, // 左右の余白
                    ),
                  ),
                  onPressed: () =>
                      widget.onEditButtonPressed(context, "経歴", widget.career),
                  child: const Text(
                    '編集',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
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
