import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String assetPath;

  const Logo({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final logoSize = screenWidth * 0.42;

    return Center(
      child: SizedBox(
        width: logoSize,
        height: logoSize * 0.75,
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}