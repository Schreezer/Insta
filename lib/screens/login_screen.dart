import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:instagram/utils/colors.dart";
// import "package:instagram/utils/colors.dart";
import "../Widgets/text_field_input.dart";
// import "assets/images/instagram_logo.svg";

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              SvgPicture.asset(
                "assets/ic_instagram.svg",
                height: 45,
                color: primaryColor,
              ),
              const SizedBox(height: 64),
              TextFieldInput(
                hintText: "Enter your E-mail",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter the Password",
                textInputType: TextInputType.text,
                isPass: true,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  // Your function here
                },
                child: Container(
                  child: const Text("Log in"),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  child: const Text("Don't have an account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                SizedBox(width: 3),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    
                  ),
                ),
              ]),
            ], // Children of Column
          )),
    ));
  }
}
