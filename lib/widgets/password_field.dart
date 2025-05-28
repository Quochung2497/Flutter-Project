import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordField extends StatefulWidget{
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onForgotPassword;

  const PasswordField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.onForgotPassword,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => passwordFieldState();
}

class passwordFieldState extends State<PasswordField>
{
  bool obscure = true;

  void toggle() => setState(() => obscure = !obscure);

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Text(widget.label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.visiblePassword,
          inputFormatters: widget.inputFormatters,
          obscureText: obscure,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: toggle,
            ),
          ),
          validator: widget.validator ?? (value){
            if(value == null || value.isEmpty)
              return 'Please enter ${widget.label}';
            return null;
          },
        ),
        if(widget.onForgotPassword != null)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Forget Password'),
            ),
          ),
      ],
    );
  }
}