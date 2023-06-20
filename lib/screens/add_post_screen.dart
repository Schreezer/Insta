
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/firestore_methods.dart';
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
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  // Rest of the code...

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: _file == null
            ? const Text("Add a Photo")
            : const Text("Change Photo"),
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
                  _file = file;
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
                  _file = file;
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
  void clearImage(){
    setState(() {
      _file = null;
      _descriptionController.clear();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  void postImage(
    String uid,
    String username,
    String description,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == 'success') {

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
    final User? user = Provider.of<UserProvider>(context).getUser;
    print("batman is here");
    var pic = (user?.photoUrl == '' || user?.photoUrl == null)
        ? "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png"
        : user?.photoUrl.toString();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: const Text("Create Post"),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: clearImage,
            ),
            actions: [
              TextButton(
                  onPressed: () => postImage(user!.uid, user.userName,
                      _descriptionController.text, user.photoUrl),
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
          child: Stack( children: [Column(children: [

            const SizedBox(height: 8),
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
                      hintText: "Write a caption...",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 222, 220, 220)),
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
                  tooltip: _file == null ? 'add photo' : 'change photo',
                ),

                const Divider(
                  color: Colors.grey,
                ),
              ],
            ),
            _file == null
                ? Container(
                    child: const Text("No Image Selected"),
                  )
                : Image.memory(_file!),
          ]),
          _isLoading ? 
          const LinearProgressIndicator(): Container(),
          ]),
        ));
  }
}
