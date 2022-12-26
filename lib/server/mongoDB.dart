import 'package:mongo_dart/mongo_dart.dart'
    show Db, DbCollection, ObjectId, modify, where;
import 'package:relay/models/post_model.dart';
import 'package:relay/widgets/feed_post_box.dart';

class MDB {
  static Db? db;
  static connect() async {
    db = await Db.create(
        "mongodb+srv://admin:Vb1.vb1.@relay.0xs8hws.mongodb.net/relay/?retryWrites=true&w=majority");
    await db!.open();
  }

  static Stream<Map<String, dynamic>> getPosts() {
    var data = db!.collection('posts').find().asBroadcastStream();    // var flag = data.map((e) => PostModel.fromJson(e)).toList();
    return data;
  }

  static Future uploadPost(PostModel post) async {
    await db!.collection('posts').insertOne(post.toJson()).then((value) async {
      await db!
          .collection('posts')
          .update(where.eq("_id", value.id), modify.set("postId", value.id));
    });
  }
}
