import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'title_widget.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String logoAsset;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Logo(assetPath: logoAsset),
        const SizedBox(height: 16),
        TitleBlock(title: title, subtitle: subtitle),
        const SizedBox(height: 24),
      ],
    );
  }
}