import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:instagram/resources/auth_methos.dart";
import "package:instagram/utils/colors.dart";
// import "package:instagram/utils/colors.dart";
import "../Widgets/text_field_input.dart";
// import "assets/images/instagram_logo.svg";

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _visibility = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
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
              //circular widget for profile picture
              const SizedBox(height: 24),
              Stack(children: [
                CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://png.pngtree.com/png-vector/20191116/ourmid/pngtree-beautiful-admin-roles-line-vector-icon-png-image_1992804.jpg")),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {},
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
              // Password TextField
              TextFieldInput(
                hintText: "Password (More than 6 characters)",
                textInputType: TextInputType.text,
                isPass: true,
                textEditingController: _passwordController,
              ),

              const SizedBox(height: 20),
              // Sign Up Button
              InkWell(
                onTap: () async {
                  print(_emailController);
                  print(_passwordController.text);
                  print(_bioController.text);
                  print(_usernameController.text);


                  String res = await AuthMethods().signupUser(
                    mail: _emailController.text,
                    password: _passwordController.text,
                    bio: _bioController.text,
                    userName: _usernameController.text,
                    // Random Uint8List being input to file
                  );
                  // Your onTap code here
                  // print(res);
                },
                splashColor: const Color.fromARGB(
                    255, 145, 244, 175), // Custom splash color
                child: Ink(
                  child: const Center(child: Text("Sign Up")),
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
                ),
              ),

              const SizedBox(height: 12),
              Flexible(flex: 2, child: Container()),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  child: const Text("Already have an Account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                const SizedBox(width: 3),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Log In",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
            ], // Children of Column
          )),
    ));
  }
}
