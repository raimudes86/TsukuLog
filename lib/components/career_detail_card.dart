import 'package:flutter/material.dart';
import 'package:tsukulog/components/career_icon.dart';

class CareerDetailCard extends StatefulWidget {
  final String id;
  final bool isBestCareer;
  final String title;
  final String category;
  final String startGrade;
  final int startMonth;
  final String span;
  final int difficultLevel;
  final int recommendLevel;
  final String reason;
  final String comment;

  const CareerDetailCard({
    super.key,
    required this.id,
    required this.isBestCareer,
    required this.title,
    required this.category,
    required this.startGrade,
    required this.startMonth,
    required this.span,
    required this.difficultLevel,
    required this.recommendLevel,
    required this.reason,
    required this.comment,
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
            // Text(
            //   widget.id == null
            //   ? 'idがnullです'
            //   : widget.id.isEmpty
            //       ? 'idがありません'
            //       : widget.id,
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: Colors.grey
            //   ),
            // ), // デバッグ用
            // 左のアイコンとタイトルの行
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左側のアイコン
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CareerIcon(categoryName: widget.category),
                  ],
                ),
                const SizedBox(width: 10),
                // タイトルとカテゴリ
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
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
                          widget.category,
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
                      '${widget.startGrade}/${widget.startMonth}月から',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF252525),
                      ),
                    ),
                    Text(
                      widget.span,
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
                    _buildStarRating(widget.difficultLevel),
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
                    _buildStarRating(widget.recommendLevel),
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
              widget.reason,
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
              widget.comment,
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
