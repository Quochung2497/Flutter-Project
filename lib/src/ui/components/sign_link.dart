import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class SignTextLink extends StatelessWidget {
  final VoidCallback onTap;
  final String normalText;
  final String linkText;

  const SignTextLink({
    Key? key,
    required this.onTap,
    required this.normalText,
    required this.linkText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;
    final linkStyle = defaultStyle?.copyWith(
      color: const Color(0xFFFFC600),
      fontWeight: FontWeight.bold,
    );

    return Center(
      child: RichText(
        text: TextSpan(
          style: defaultStyle,
          children: [
            TextSpan(text: normalText),
            TextSpan(
              text: linkText,
              style: linkStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
