import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsCheckbox extends StatefulWidget{
  final ValueChanged<bool> onChanged;
  const TermsAndConditionsCheckbox({Key? key, required this.onChanged}) : super(key: key);

  @override
  TermsAndConditionsCheckboxState createState() => TermsAndConditionsCheckboxState();
}

class TermsAndConditionsCheckboxState extends State<TermsAndConditionsCheckbox>
{
  bool agreed = false;
  bool canCheck = false;
  final termsRecognizer = TapGestureRecognizer();

  void showTermsDialog() {
    showDialog(context: context,
        builder: (_) => AlertDialog(
          title: const Text('Terms & Conditions'),
          content: const Text('Placeholder for T&C text'),
          actions:[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                  canCheck = true; // ✅ Enable checkbox only after reading
                  });
                },
                child: const Text('Close'),
            )
          ],
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    termsRecognizer.onTap = showTermsDialog;
  }

  @override
  void dispose() {
    termsRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    termsRecognizer.onTap = showTermsDialog;
    var color = Color(0xFFFFC600);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: agreed,
          onChanged: canCheck
              ? (value) {
              setState(() => agreed = value ?? false);
              widget.onChanged(agreed);
              }
              : null,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'I agree with '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: color,
                    decoration: TextDecoration.underline,
                  ),
                    recognizer: termsRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
