import "package:cloud_firestore/cloud_firestore.dart";
import "package:country_picker/country_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:instagram/Widgets/standard_button.dart";
import "package:instagram/screens/signup_screen.dart";
import "package:instagram/utils/utils.dart";
import "package:intl_phone_field/intl_phone_field.dart";
import "package:provider/provider.dart";
import "../Widgets/text_field_input.dart";
import "../main.dart";
import "../providers/user_provider.dart";
import "../resources/auth_methos.dart";
import "../utils/global_variables.dart";
import 'dart:html' as html;



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading1 = false;
  bool _isLoading2 = false;
  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _otpController.dispose();
  }

  void sendOtp() async {
    setState(() {
      _isLoading1 = true;
    });
    String res =
        await AuthMethods().Login_otp(phone: _phoneNumberController.text);

    print(res);
    if (res == 'success') {
      showSnackBar(res, context);
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading1 = false;
    });
  }

  Future<void> Next(Provider) async {
    // ignore: unused_local_variable
    var res = 'otp entered';
    setState(() {
      _isLoading2 = true;
    });
    await AuthMethods()
        .Login_otp_submit(_otpController.text)
        .then((value) => res = value);

    if (res == 'success') {
      if (!context.mounted) return;
      showSnackBar(res, context);

      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String? uid = auth.currentUser?.uid.toString();
      G_uid = uid!;
      PhoneNumber = _phoneNumberController.text;
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot == null || !snapshot.exists) {
        if (!context.mounted) return;
        Provider.refreshUser(false);
        PhoneNumber = _phoneNumberController.text;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SignupScreen(),
          ),
        );
      } else {
        if (!context.mounted) return;
        Provider.refreshUser(false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MyApp(),
            ));
        html.window.location.reload();
        
      }
    } else {
      if (!context.mounted) return;
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading2 = false;
    });
  }

  void navigateToSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3)
                  : const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(flex: 2, child: Container()),
                  // SvgPicture.asset(
                  //   "assets/ic_instagram.svg",
                  //   height: 45,
                  //   color: primaryColor,
                  // ),
                  const Text(
                    "Bountier",
                    style: TextStyle(
                      fontFamily: "Billabong",
                      fontSize: 50,
                    ),
                  ),
                  const SizedBox(height: 64),

                  IntlPhoneField(
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      filled: true,
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    // controller: _phoneNumberController,
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      setState(() {
                         _phoneNumberController.text = phone.completeNumber;
                      });
                     
                    },
                  ),
                  // TextFieldInput(
                  //   hintText: "Enter your Phone Number with country code",
                  //   textInputType: TextInputType.emailAddress,
                  //   textEditingController: _phoneNumberController,
                  // ),
                  const SizedBox(height: 2),
                  StandardButton(
                    function: sendOtp,
                    isLoading: _isLoading1,
                    displayText: "Send OTP",
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    hintText: "Enter the otp",
                    textInputType: TextInputType.text,
                    isPass: true,
                    textEditingController: _otpController,
                  ),
                  const SizedBox(height: 24),
                  StandardButton(
                    function: () => Next(userProvider),
                    isLoading: _isLoading2,
                    displayText: "Next",
                  ),
                  const SizedBox(height: 12),
                  Flexible(flex: 2, child: Container()),
                  // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(vertical: 8),
                  //     child: const Text("Don't have an account?"),
                  //   ),
                  //   const SizedBox(width: 3),
                  //   MouseRegion(
                  //     cursor: SystemMouseCursors.click,
                  //     child: GestureDetector(
                  //       onTap: navigateToSignup,
                  //       child: Container(
                  //         padding: const EdgeInsets.symmetric(vertical: 8),
                  //         child: const Text(
                  //           "Create Account",
                  //           style: TextStyle(fontWeight: FontWeight.bold),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ]),
                ], // Children of Column
              )),
        ));
  }
}
