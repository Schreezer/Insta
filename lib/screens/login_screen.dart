import "package:flutter/material.dart";
import "package:instagram/Widgets/standard_button.dart";
import "package:instagram/screens/signup_screen.dart";
import "package:instagram/utils/colors.dart";
import "package:instagram/utils/utils.dart";
// import "package:instagram/utils/colors.dart";
import "../Widgets/text_field_input.dart";
// import "assets/images/instagram_logo.svg";
import "../resources/auth_methos.dart";
import "../responsive/moblie_screen_layout.dart";
import "../responsive/responsive_layout_screen.dart";
import "../responsive/web_screen_layout.dart";
import "../utils/global_variables.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _otpController.dispose();
  }

  void loginUser() async {
    // ignore: unused_local_variable
    var res = 'otp entered';
    setState(() {
      _isLoading = true;
    });
    res = await AuthMethods().Login_otp_submit(_otpController.text);
    setState(() {
      _isLoading = false;
    });
    if (res == 'success') {
      showSnackBar(res, context);
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //       builder: (context) => const ResponsiveLayout(
      //             mobileScreenLayout: MobileScreenLayout(),
      //             webScreenLayout: WebScreenLayout(),
      //           )),
      // );
      Navigator.of(context).pop();
    } else {
      showSnackBar(res, context);
    }
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
                  TextFieldInput(
                    hintText: "Enter your Phone Number",
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _phoneNumberController,
                  ),
                  const SizedBox(height: 24),
                  StandardButton(
                    function: ()=>  AuthMethods().Login_otp(phone: _phoneNumberController.text),
                    isLoading: _isLoading,
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
                    function: ()=> loginUser(),
                    isLoading: _isLoading,
                    displayText: "Login",
                  ),
                  const SizedBox(height: 12),
                  Flexible(flex: 2, child: Container()),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Don't have an account?"),
                    ),
                    const SizedBox(width: 3),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: navigateToSignup,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Create Account",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ], // Children of Column
              )),
        ));
  }
}
