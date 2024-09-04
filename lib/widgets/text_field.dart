import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final bool validate;
  final String errorText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    required this.validate,
    required this.errorText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool hideText;
  late bool error;

  @override
  void initState() {
    super.initState();
    hideText = widget.isPassword;
    error = widget.validate;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    reload();
  }

  reload() {
    setState(() {
      hideText = widget.isPassword;
      error = widget.validate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: TextField(
          controller: widget.controller,
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                error = false;
              });
            }
          },
          decoration: InputDecoration(
            helperText: " ",
            hintText: widget.hintText,
            errorText: error ? widget.errorText : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() {
                      hideText = !hideText;
                    }),
                    icon: Icon(hideText ? Icons.visibility_off : Icons.visibility),
                  )
                : null,
          ),
          obscureText: hideText,
        ),
      ),
    );
  }
}
