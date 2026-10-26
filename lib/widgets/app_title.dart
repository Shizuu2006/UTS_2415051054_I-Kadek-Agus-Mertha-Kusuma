import 'package:flutter/material.dart';

import '../constants.dart';

class AppTitle extends StatelessWidget {
  final String title;
  const AppTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title),
      Text(
        '$studentName • $studentNim',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}
