import 'package:flutter/material.dart';
import 'package:tsukulog/components/career_detail_card.dart';
import 'package:tsukulog/models/career_history.dart';

class CareerHistoryCard extends StatefulWidget {
  final String nickname;
  final String bestCareerId;
  final List<CareerHistory> careerHistories;

  const CareerHistoryCard({
    super.key,
    required this.nickname,
    required this.bestCareerId,
    required this.careerHistories,
  });

  @override
  State<CareerHistoryCard> createState() => _CareerHistoryCardState();
}

class _CareerHistoryCardState extends State<CareerHistoryCard> {
  bool _isOldestToNewest = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // セクションタイトル
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.double_arrow, color: Color(0xFF252525)),
              SizedBox(width: 4),
              Text(
                widget.nickname + 'の経歴',
                style: TextStyle(
                  color: Color(0xFF252525),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 経歴ごとのカード
          ...widget.careerHistories.map(
            (career) => CareerDetailCard(
              id: career.id,
              isBestCareer: career.id == widget.bestCareerId,
              title: career.title, 
              category: career.category, 
              startGrade: career.startGrade, 
              startMonth: career.startMonth,
              span: career.span, 
              difficultLevel: career.difficultLevel, 
              recommendLevel: career.recommendLevel, 
              reason: career.reason, 
              comment: career.comment)
          ),
        ],
      ),
    );
  }
}