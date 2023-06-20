import "dart:typed_data";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:instagram/resources/auth_methos.dart";
import "package:instagram/screens/login_screen.dart";
import "package:instagram/screens/otp_screen.dart";
import "package:instagram/utils/colors.dart";
// import "package:instagram/utils/colors.dart";
import "../Widgets/text_field_input.dart";
import "../utils/utils.dart";
// import "assets/images/instagram_logo.svg";

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final bool _visibility = false;
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  // the only button (to be clicked when the otp is to be sent, ie when the user has filled the first form)
  void sendOtp() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().sendOtp(
        _phoneNumberController.text,
        _emailController.text,
        _usernameController.text,
        _bioController.text,
        _image);
    setState(() {
      _isLoading = false;
    });
    print("the res here is: ");
    print("the value of res is:$res");
    // wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    if (res == 'code sent') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => OtpScreen(),
        ),
      );
    }
  }
  // void signupUser() async {
  //   print(_isLoading);
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   String res = await AuthMethods().signupUser(
  //     mail: _emailController.text,
  //     otp: _otpController.text,
  //     bio: _bioController.text,
  //     userName: _usernameController.text,
  //     file: _image,
  //   );

  //   setState(() {
  //     _isLoading = false;
  //   });
  //   if (res != 'success') {
  //     showSnackBar(res, context);
  //   } else {
  //     showSnackBar("Sign Up successful", context);
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //           builder: (context) => const ResponsiveLayout(
  //                 mobileScreenLayout: MobileScreenLayout(),
  //                 webScreenLayout: WebScreenLayout(),
  //               )),
  //     );
  //   }
  // }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  void navigateToOtp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => OtpScreen(),
      ),
    );
  }

  @override
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
              const Text(
                "Bountier",
                style: TextStyle(
                  fontFamily: "Billabong",
                  fontSize: 50,
                ),
              ),
              //circular widget for profile picture
              const SizedBox(height: 24),
              Stack(children: [
                _image != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            "https://png.pngtree.com/png-vector/20191116/ourmid/pngtree-beautiful-admin-roles-line-vector-icon-png-image_1992804.jpg")),
                Positioned(
                  bottom: 0,
                  left: 70,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              // Username TextField
              TextFieldInput(
                hintText: "Username",
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(height: 20),
              // Bio TextField
              TextFieldInput(
                hintText: "Bio",
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(height: 20),
              // Email TextField
              TextFieldInput(
                hintText: "E-mail",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(height: 24),
              // Phone numebr field:
              TextFieldInput(
                hintText: "Phone number with country code",
                textInputType: TextInputType.phone,
                textEditingController: _phoneNumberController,
              ),
              const SizedBox(height: 24),
              // Password TextField
              // TextFieldInput(
              //   hintText: "Password (More than 6 characters)",
              //   textInputType: TextInputType.text,
              //   isPass: true,
              //   visibility: false,
              //   textEditingController: _otpController,
              // ),

              const SizedBox(height: 20),
              // Sign Up Button
              InkWell(
                onTap: sendOtp,
                splashColor: const Color.fromARGB(
                    255, 145, 244, 175), // Custom splash color
                child: Ink(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Center(child: Text("Get OTP")),
                ),
              ),

              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Already have an Account?"),
                ),
                const SizedBox(width: 3),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        "Log In",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
            ], // Children of Column
          )),
    ));
  }
}
