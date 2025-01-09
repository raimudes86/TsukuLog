import 'package:flutter/material.dart';
import 'package:tsukulog/pages/show_page.dart';

class UserButton extends StatelessWidget {
  final String label;
  final String uid;

  const UserButton({
    Key? key,
    required this.label,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowPage(uid: uid),
              ),
            );
          },
          child: Text(label),
        ),
      ],
    );
  }
}
