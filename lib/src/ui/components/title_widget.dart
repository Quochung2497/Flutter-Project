import 'package:flutter/material.dart';

class TitleBlock extends StatelessWidget {
  final String title;
  final String subtitle;

  const TitleBlock({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(title, style: theme.headlineSmall),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: Text(
            subtitle,
            style: theme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}