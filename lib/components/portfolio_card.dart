import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tsukulog/models/portfolio.dart';

class PortfolioCard extends StatelessWidget {
  final List<PortFolio> portfolios;
  final bool isMyPage;
  final Function onEditButtonPressed;

  const PortfolioCard({
    super.key,
    required this.portfolios,
    required this.isMyPage,
    required this.onEditButtonPressed,
  });

  // URLを開くメソッド
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

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
              Icon(Icons.build, color: Color(0XFF252525)),
              const SizedBox(width: 4),
              const Text(
                '制作物・成果物',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                  for (var portfolio in portfolios)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: portfolio.link.isNotEmpty
                              ? () => _launchURL(portfolio.link)
                              : null,
                          child: Text(
                            portfolio.name,
                            style: TextStyle(
                              color: portfolio.link.isNotEmpty
                                  ? Colors.blue // リンクがある場合は青色
                                  : Color(0XFF252525), // デフォルト色
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: portfolio.link.isNotEmpty
                                  ? TextDecoration.underline // 下線を追加
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          portfolio.comment,
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
                                      context, "制作物・成果物", portfolio),
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
