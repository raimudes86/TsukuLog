import 'package:flutter/material.dart';
import 'package:tsukulog/models/lesson.dart';

class LessonCard extends StatelessWidget {
  final List<Lesson> lessons;
  final bool isMyPage;
  final Function onEditButtonPressed;

  const LessonCard({
    super.key,
    required this.lessons,
    required this.isMyPage,
    required this.onEditButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.menu_book, color: Color(0XFF252525)),
              const SizedBox(width: 4),
              const Text(
                'おすすめの授業',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Container(
              width: MediaQuery.of(context).size.width, // 画面全幅に設定
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var lessons in lessons)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lessons.name,
                          style: const TextStyle(
                            color: Color(0XFF252525),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lessons.comment,
                          style: const TextStyle(
                            color: Color(0XFF252525),
                            fontSize: 14,
                          ),
                        ),
                        if (isMyPage)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyan[400], // 背景色
                                    foregroundColor: Colors.white, // 文字色
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4, // 上下の余白
                                      horizontal: 4, // 左右の余白
                                    ),
                                  ),
                                  onPressed: () => onEditButtonPressed(
                                      context, "おすすめの授業", lessons),
                                  child: const Text(
                                    '編集',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                        const SizedBox(height: 8),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
