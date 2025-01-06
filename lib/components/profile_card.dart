import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String nickname;
  final String grade;
  final String major;
  final String futurePath;
  final int star;
  // final String imageUrl;

  const ProfileCard({
    Key? key,
    required this.nickname,
    required this.grade,
    required this.major,
    required this.futurePath,
    required this.star,
    // required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF9424E3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 星アイコンとスター数
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.star, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                '参考になった $star',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 名前
          Text(
            nickname,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // 学年と専攻
          Text(
            '$grade  $major',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          // 進路情報
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 230, 230, 230),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '  $futurePath  ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
