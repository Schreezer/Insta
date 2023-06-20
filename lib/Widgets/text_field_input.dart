import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  bool visibility;
  final TextInputType textInputType;

  TextFieldInput({super.key, 
   
    required this.textEditingController,
    this.isPass = false,
    this.visibility = true,
    required this.hintText,
    required this.textInputType,
  });

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  void updateStatus() {
    setState(() {
      widget.visibility = !widget.visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: Divider.createBorderSide(context),
    );

    return TextField(
      controller: widget.textEditingController,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),

        // Use the 'suffix' property of InputDecoration
        suffixIcon: widget.isPass
            ? IconButton(
                icon: Icon(widget.visibility ? Icons.visibility : Icons.visibility_off),
                onPressed: updateStatus,
              )
            : null,
      ),
      keyboardType: widget.textInputType,
      obscureText: !widget.visibility && widget.isPass,
    );
  }
}
