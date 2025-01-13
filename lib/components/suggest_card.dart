import 'package:flutter/material.dart';
import 'package:tsukulog/models/suggest.dart';

class SuggestCard extends StatelessWidget {
  final List<Suggest> suggests;

  const SuggestCard({
    super.key,
    required this.suggests,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Icon(Icons.double_arrow, color: Color(0xFF252525)),
            SizedBox(width: 4),
            Text(
              'これだけはやっておけ！！！',
              style: TextStyle(
                color: Color(0xFF252525),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var suggest in suggests)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggest.name,
                      style: const TextStyle(
                        color: Color(0XFF252525),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suggest.comment,
                      style: const TextStyle(
                        color: Color(0XFF252525),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
            ],
          ), 
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}