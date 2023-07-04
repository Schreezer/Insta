import "dart:typed_data";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:instagram/main.dart";
import "package:instagram/resources/auth_methos.dart";
import "package:instagram/screens/login_screen.dart";
import "package:instagram/utils/colors.dart";
import "package:provider/provider.dart";
// import "package:instagram/utils/colors.dart";
import "../Widgets/text_field_input.dart";
import "../providers/user_provider.dart";
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<String> Next() async {
    String result;
    setState(() {
      _isLoading = true;
    });
    try {
      result = await AuthMethods().signupUser(
          mail: _emailController.text,
          bio: _bioController.text,
          userName: _usernameController.text,
          phoneNumber: _auth.currentUser!.phoneNumber.toString(),
          uid: _auth.currentUser!.uid,
          file: _image);
    } catch (e) {
      print(e);
      result = 'error';
    }
    showSnackBar(result, context);
    setState(() {
      _isLoading = false;
    });
    return result;
  }

  void navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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

              const SizedBox(height: 20),
              // Sign Up Button
              InkWell(
                onTap: () async {
                  if (await Next() == 'success') {
                    userProvider.refreshUser(false);
                    print("Next was success");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyApp(),
                      ),
                    );
                  }
                },

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
                      : const Center(child: Text("Next")),
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
