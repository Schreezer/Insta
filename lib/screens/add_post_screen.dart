import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/firestore_methods.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<Uint8List> upload_images = [];
  // Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bountyController = TextEditingController();

  bool _isLoading = false;
  // Rest of the code...

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add a Photo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Photo with Camera"),
              onTap: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  upload_images.add(file);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Image from Gallery"),
              onTap: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  upload_images.add(file);
                  // _file = file;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void clearImage() {
    setState(() {
      // _file = null;
      _bountyController.clear();
      upload_images.clear();
      _descriptionController.clear();
    });
  }

  void clearImageAtIndex(int index) {
    setState(() {
      upload_images.removeAt(index);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
    _bountyController.dispose();
    upload_images.clear();
  }

  void postImage(
    String uid,
    String username,
    String description,
    String profImage,
    int bounty,
    int tokens,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (bounty >= tokens) {
        showSnackBar("Not enough tokens", context);
        throw Exception("Not enough tokens");
      }
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text,
          upload_images,
          uid,
          int.parse(_bountyController.text),
          username,
          profImage);
      if (res == 'success') {
        res = await StorageMethods()
            .updateTokens(tokens - int.parse(_bountyController.text));
        showSnackBar("Posted", context);
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bounty = 10;
    final User? user = Provider.of<UserProvider>(context).getUser;
    var pic = (user?.photoUrl == '' || user?.photoUrl == null)
        ? "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png"
        : user?.photoUrl.toString();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: const Text("Create Bounty"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: clearImage,
            ),
            actions: [
              TextButton(
                  onPressed: () => postImage(
                      user!.uid,
                      user.userName,
                      _descriptionController.text,
                      user.photoUrl,
                      bounty,
                      user.tokens),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )),
            ]), //Actions
        body: SingleChildScrollView(
          child: Stack(children: [
            Column(children: [
              const SizedBox(height: 8),
              Row(children: [
                const SizedBox(width: 6),
                Text(
                  "Set Bounty: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 222, 220, 220),
                  ),
                ),
                const SizedBox(width: 26),
                SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.48,
                  child: TextField(
                    controller: _bountyController,
                    decoration: InputDecoration(
                      hintText: "Max Bounty: ${user!.tokens}",
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 153, 148, 148),
                          backgroundColor: Color.fromARGB(255, 52, 52, 52)),
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(pic!),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.48,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Write a description...",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 222, 220, 220)),
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  // SizedBox(
                  //     height: 45,
                  //     width: 45,
                  //     child: AspectRatio(
                  //         aspectRatio: 487 / 451,
                  //         child: Container(
                  //           decoration: BoxDecoration(
                  //             image: DecorationImage(
                  //               image:
                  //                   NetworkImage("https://loremflickr.com/320/240"),
                  //               fit: BoxFit.fill,
                  //               alignment: FractionalOffset.topCenter,
                  //             ),
                  //           ),
                  //         ))),
                  IconButton(
                    icon: const Icon(Icons.add_a_photo),
                    onPressed: () => _selectImage(context),
                    tooltip: 'add photo',
                  ),

                  const Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
              upload_images.length == 0
                  ? Container(
                      child: const Text("No Image Selected"),
                    )
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: upload_images.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(8),
                                child: Image.memory(upload_images[index]),
                              ),
                              Positioned(
                                top: 0, // to position it at the top
                                right: 0, // to position it at right
                                child: IconButton(
                                  icon:
                                      Icon(Icons.clear), // change it as needed
                                  onPressed: () => clearImageAtIndex(index),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    )
            ]),
            _isLoading ? const LinearProgressIndicator() : Container(),
          ]),
        ));
  }
}
