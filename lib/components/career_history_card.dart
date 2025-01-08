import 'package:flutter/material.dart';
import 'package:tsukulog/components/career_detail_card.dart';
import 'package:tsukulog/models/career_history.dart';

class CareerHistoryCard extends StatefulWidget {
  final List<CareerHistory> careerHistories;

  const CareerHistoryCard({
    Key? key,
    required this.careerHistories,
  }) : super(key: key);

  @override
  _CareerHistoryCardState createState() => _CareerHistoryCardState();
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
          const Text(
            '経歴',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 8),

          // 経歴ごとのカード
          ...widget.careerHistories.map(
            (career) => CareerDetailCard(
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