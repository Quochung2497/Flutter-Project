import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabelTextField extends StatelessWidget{
  final String label;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const LabelTextField({
    Key? key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.controller,
 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            enableInteractiveSelection: false,
            validator: validator ??
                (value){
                  if(value == null || value.isEmpty){
                    return 'Please enter $label';
                  }
                  return null;
                },
            ),
          ],
    );
  }
}