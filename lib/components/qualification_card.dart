import 'package:flutter/material.dart';
import 'package:tsukulog/models/qualification.dart';

class QualificationCard extends StatelessWidget {
  final List<Qualification> qualifications;

  const QualificationCard({
    super.key,
    required this.qualifications,
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
              Icon(Icons.workspace_premium, color: Color(0XFF252525)),
              const SizedBox(width: 4),
              const Text(
                '資格・受賞歴',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
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
                  for (var qualification in qualifications)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          qualification.name,
                          style: const TextStyle(
                            color: Color(0XFF252525),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          qualification.year,
                          style: const TextStyle(
                            color: Color(0XFF252525),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}