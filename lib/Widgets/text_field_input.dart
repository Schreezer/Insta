import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  bool visibility;
  final TextInputType textInputType;

  TextFieldInput({
    Key? key,
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
      controller: widget.textEditingController, // Use the received TextEditingController
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: widget.textInputType,
      obscureText: widget.isPass,
    );
  }
}
