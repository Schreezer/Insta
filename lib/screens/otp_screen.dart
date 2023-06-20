import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:instagram/resources/auth_methos.dart";

class OtpScreen extends StatefulWidget {
  OtpScreen({super.key});
  TextEditingController otpController = TextEditingController();
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const Text("Otp Verification"),
          TextFormField(
            controller: widget.otpController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              hintText: "Enter Otp",
            ),
          ),
          ElevatedButton(
            child: const Text("Submit Otp"),
            onPressed: ()async{
              String reg = await AuthMethods().Register(widget.otpController.text);
              if(reg=="success"){
                Navigator.of(context).pop();
              }
              })
              ,
        ]
      ),
    );
  }
}