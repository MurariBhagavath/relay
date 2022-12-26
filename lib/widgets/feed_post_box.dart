import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' as MD;
import 'package:relay/models/post_model.dart';
import 'package:relay/server/mongoDB.dart';

class FeedPost extends StatefulWidget {
  const FeedPost({super.key, required this.post});
  final PostModel post;

  @override
  State<FeedPost> createState() => _FeedPostState();
}

class _FeedPostState extends State<FeedPost> {
  Widget buildHeight(double size) {
    return SizedBox(height: size);
  }

  Widget buildWidth(double size) {
    return SizedBox(width: size);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.post.profile),
                ),
                buildWidth(10),
                AutoSizeText(
                  widget.post.name,
                  minFontSize: 16,
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
          Container(height: 300, child: Image.network(widget.post.imageUrl)),
          buildHeight(12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                widget.post.content,
                minFontSize: 16,
                maxFontSize: 20,
                maxLines: 2,
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(widget.post.likes.length.toString() + " Likes"),
              )),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    MDB.db!.collection('posts').update(
                        MD.where.eq('postId', widget.post.postId),
                        MD.modify.push('likes', widget.post.uid));
                  },
                  icon: FaIcon(FontAwesomeIcons.heart),
                ),
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.comment),
                ),
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.share),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
