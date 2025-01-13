import 'package:flutter/material.dart';

class CareerIcon extends StatelessWidget {
  final String categoryName;
  final double size;

  CareerIcon({super.key, required this.categoryName, this.size = 48.0});

  final Map<String, Map<String, dynamic>> _categoryStyles = {
    'アルバイト': {
      'icon': Icons.store,
      'backgroundColor': Colors.orange,
      'iconColor': Colors.white,
    },
    'ハッカソン': {
      'icon': Icons.lightbulb,
      'backgroundColor': Colors.yellow,
      'iconColor': Colors.black,
    },
    '長期インターン': {
      'icon': Icons.business_center,
      'backgroundColor': Colors.blue,
      'iconColor': Colors.white,
    },
    '短期インターン': {
      'icon': Icons.work,
      'backgroundColor': Colors.lightBlue,
      'iconColor': Colors.white,
    },
    '授業': {
      'icon': Icons.menu_book,
      'backgroundColor': Colors.green,
      'iconColor': Colors.white,
    },
    '学生組織': {
      'icon': Icons.groups,
      'backgroundColor': Colors.purple,
      'iconColor': Colors.white,
    },
    'コンペ': {
      'icon': Icons.emoji_events,
      'backgroundColor': Colors.red,
      'iconColor': Colors.white,
    },
  };

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyles[categoryName];

    if (style != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: style['backgroundColor'],
        ),
        child: Icon(
          style['icon'],
          size: size * 0.6, // アイコンのサイズ調整
          color: style['iconColor'],
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[400],
        ),
        child: Icon(
          Icons.help_outline,
          color: Colors.white,
          size: size * 0.5, // アイコンサイズを調整
        ),
      );
    }
  }
}
