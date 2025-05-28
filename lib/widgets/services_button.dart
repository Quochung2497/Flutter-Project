import 'package:flutter/material.dart';

class ServicesButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String label;

  const ServicesButton({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    const color = Color(0xFFFFC600);

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white,fontSize: 18),
        ),
      ),
    );
  }
}