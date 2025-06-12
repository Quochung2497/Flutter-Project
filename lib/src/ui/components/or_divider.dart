import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {

  final String label;

  const OrDivider({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.8,
        child: Row(
          children: [
            Expanded(
              child: Divider(
                thickness: 1,
                endIndent: 10,
                color: Colors.grey,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey),
            ),
            Expanded(
              child: Divider(
                thickness: 1,
                indent: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}