import 'package:flutter/material.dart';

class ShowPage extends StatelessWidget {
  const ShowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Show Page'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'This is the Show Page',
            ),
          ],
        ),
      ),
    );
  }
}
