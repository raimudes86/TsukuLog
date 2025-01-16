import 'package:flutter/material.dart';
import 'package:tsukulog/models/user.dart';

class UserButton extends StatelessWidget {
  const UserButton({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 仮アイコン
                CircleAvatar(
                  radius: 30,
                  // backgroundColor: Colors.blueGrey,
                  backgroundImage:
                      user.selectedIcon > 0 && user.selectedIcon < 6
                          ? AssetImage(
                              'assets/images/icon${user.selectedIcon}.webp')
                          : null, // user.selectedIconに基づいて画像パスを生成
                  child: user.selectedIcon < 1 || user.selectedIcon > 5
                      ? Text(
                          user.nickname.isNotEmpty
                              ? user.nickname[0] // 名前のイニシャルを表示
                              : '仮',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16.0),

                // majorとgradeを表示
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.major} ${user.grade}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          user.futurePath,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      user.nickname,
                      style: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          user.like.toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // タグ表示
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: user.tags.map((tag) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),

            // 関連企業リスト
            Row(
              children: [
                const Icon(Icons.apartment),
                const SizedBox(width: 8.0),
                const Text(
                  '関わったことのある企業',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...user.companies.map(
              (company) => Text(
                company,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
