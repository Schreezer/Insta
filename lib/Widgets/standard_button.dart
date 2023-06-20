import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class StandardButton extends StatefulWidget {
  final Function()? function;
  bool isLoading;
  String displayText;

  StandardButton({
    Key? key,
    required this.function,
    this.isLoading = false,
    required this.displayText,
  }) : super(key: key);

  @override
  _StandardButtonState createState() => _StandardButtonState();
}

class _StandardButtonState extends State<StandardButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: widget.function,
        focusColor: Colors.blue.withOpacity(0.4),
        hoverColor: Color.fromARGB(255, 250, 52, 92).withOpacity(0.2),
        highlightColor: Colors.blue.withOpacity(0.6),
        splashColor: Colors.blue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            color: blueColor,
          ),
          child: widget.isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(widget.displayText),
        ),
      ),
    );
  }
}
