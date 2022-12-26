import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:relay/models/post_model.dart';
import 'package:relay/server/mongoDB.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String content = '';
  bool isUploaded = false;
  String imageUrl = "";

  final _auth = FirebaseAuth.instance.currentUser;

  Reference storageRef = FirebaseStorage.instance.ref();
  Future<String> uploadToStorage(XFile img) async {
    Reference postsRef = storageRef.child('posts');
    var uploadedImg = await postsRef.putFile(File(img.path));
    if (uploadedImg.state == TaskState.success) {
      imageUrl = await postsRef.getDownloadURL();
    } else {}
    return imageUrl;
  }

  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    if (await Permission.storage.request().isGranted) {
      var img = await picker.pickImage(source: media);
      var imgUrl = await uploadToStorage(img!);
      setState(() {
        image = img;
        isUploaded = true;
        imageUrl = imgUrl;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Allow permission'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Post'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isUploaded
                ? Image.file(File(image!.path),
                    height: 280, width: double.infinity)
                : SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          await getImage(ImageSource.gallery);
                        },
                        child: Text('Add an image'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 40),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    content = value;
                  });
                },
                maxLines: 2,
                style: TextStyle(fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                  labelText: 'Write something',
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                var name = _auth!.displayName;
                var profile = _auth!.photoURL;
                PostModel post = PostModel(
                    uid: _auth!.uid,
                    name: name!,
                    content: content,
                    imageUrl: imageUrl,
                    likes: [],
                    profile: profile!);
                await MDB.uploadPost(post);
                Navigator.pop(context);
              },
              icon: FaIcon(FontAwesomeIcons.fileUpload),
              label: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
