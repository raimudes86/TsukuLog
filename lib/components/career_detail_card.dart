import 'package:flutter/material.dart';

class CareerDetailCard extends StatefulWidget {
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
    Key? key,
    required this.title,
    required this.category,
    required this.startGrade,
    required this.startMonth,
    required this.span,
    required this.difficultLevel,
    required this.recommendLevel,
    required this.reason,
    required this.comment,
  }) : super(key: key);

  @override
  _CareerDetailCardState createState() => _CareerDetailCardState();
}

class _CareerDetailCardState extends State<CareerDetailCard> {
  bool _isCommentVisible = false; // 感想が表示されているかどうかを管理するフラグ

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
            // 左のアイコンとタイトルの行
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左側のアイコン
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[400],
                      ),
                      child: const Center(
                        child: Text(
                          '*',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.startGrade}/${widget.startMonth}月から',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF252525),
                      ),
                    ),
                    Text(
                      '${widget.span}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF252525),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
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
              ],
            ),
            const SizedBox(height: 16),

            // ハードルとおすすめ度の星評価
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ハードル', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    _buildStarRating(widget.difficultLevel),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('おすすめ度', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    _buildStarRating(widget.recommendLevel),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 理由
            Text(
              widget.reason,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0XFF252525),
              ),
            ),
            const SizedBox(height: 8),

            // 感想を見るリンク
            InkWell(
              onTap: () {
                // 感想を表示・非表示切り替え
                setState(() {
                  _isCommentVisible = !_isCommentVisible;
                });
              },
              child: Text(
                _isCommentVisible ? '感想を閉じる' : '感想を見る',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // 感想（表示・非表示）
            if (_isCommentVisible)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  widget.comment,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0XFF252525),
                  ),
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