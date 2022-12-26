import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:relay/models/post_model.dart';
import 'package:relay/provider/google_sign_in.dart';
import 'package:relay/screens/sub_screens/add_post_screen.dart';
import 'package:relay/server/mongoDB.dart';
import 'package:relay/widgets/feed_post_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final googleUser = FirebaseAuth.instance.currentUser;
  List<PostModel>? post;
  Widget buildHeight(double size) {
    return SizedBox(height: size);
  }

  Widget buildWidth(double size) {
    return SizedBox(width: size);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            buildHeight(18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Align(
                //       alignment: Alignment.centerLeft,
                //       child: AutoSizeText(
                //         'Hello!',
                //         minFontSize: 20,
                //       ),
                //     ),
                //     Align(
                //       alignment: Alignment.centerLeft,
                //       child: AutoSizeText(
                //         googleUser!.displayName.toString(),
                //         minFontSize: 24,
                //       ),
                //     ),
                //   ],
                // ),
                AutoSizeText(
                  'Relay',
                  style: TextStyle(fontSize: 28, letterSpacing: 4),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPostScreen()));
                  },
                  icon: FaIcon(FontAwesomeIcons.plusSquare),
                ),
              ],
            ),
            buildHeight(16),
            Expanded(
              // child: FutureBuilder<List<PostModel>>(
              //   future: MDB.getPosts(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       var posts = snapshot.data;
              //       return ListView.builder(
              //         itemBuilder: (context, index) {
              //           return FeedPost(post: posts[index]);
              //         },
              //         itemCount: posts!.length,
              //       );
              //     } else if (snapshot.connectionState ==
              //         ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     } else {
              //       return Center(child: Text('Error'));
              //     }
              //   },
              // ),
              child: StreamBuilder(
                stream: MDB.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var posts = snapshot.data;
                    return ListView.builder(
                        itemCount: posts!.length,
                        itemBuilder: (context, index) {
                          return FeedPost(post: posts[index]);
                        });
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
