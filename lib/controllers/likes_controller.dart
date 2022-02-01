import 'package:conduit/conduit.dart';
import 'package:backend/models/like.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/like_dto.dart';
import 'package:backend/models/following.dart';
import 'package:backend/helpers/encrypt.dart';
import 'package:backend/helpers/grab_chatter.dart';
import 'dart:convert';
class LikesController extends ResourceController {
  ManagedContext context;
  LikesController(this.context);

  @Operation.post('id')
  Future<Response> like(@Bind.path('id') int id) async {
    final likesQuery = Query<Like>(context)
      ..where((i) => i.message?.id).equalTo(id);
    final likes = await likesQuery.fetch();
    if (likes.any((l) => l.chatter == request!.authorization!.ownerID)) {
        return Response.badRequest(body: {
           'error': "you already liked this message"
        });
    }
    final messageQuery = Query<Message>(context)
      ..where((i) => i.id).equalTo(id);
    final message = await messageQuery.fetchOne();
    final chatterQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final chatter = await chatterQuery.fetchOne();
    final likeQuery = Query<Like>(context)
      ..values.message = message
      ..values.chatter = chatter
      ..values.date = DateTime.now();
    final like = await likeQuery.insert();
    return Response.ok("");
  }
  @Operation.get('id')
  Future<Response> get(@Bind.path('id') int id) async {
    final cryptorQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final cryptor = await cryptorQuery.fetchOne();
    final likesQuery = Query<Like>(context)
      ..where((i) => i.message?.id).equalTo(id);
    final likes = await likesQuery.fetch();
    final followingQuery = Query<Following>(context)
      ..where((i) => i.follower?.id).equalTo(request!.authorization!.ownerID);
    final following = await followingQuery.fetch();
    final followersQuery = Query<Following>(context)
      ..where((i) => i.chatter?.id).equalTo(request!.authorization!.ownerID);
    final followers = await followersQuery.fetch();
    final flwgIds = following.map((x) => x.chatter?.id!);
    final flwsIds = followers.map((x) => x.follower?.id!);
    final likesAsDto = likes.map((x) async => LikeDto(
      isMutual: flwgIds.contains(x.chatter?.id) || flwsIds.contains(x.chatter?.id),
      encryptedId:
      (flwgIds.contains(x.chatter?.id) || flwsIds.contains(x.chatter?.id)) ?
      eschencryschypt(await grabChatterQrId(x.chatter!.id!, context), cryptor!.secret!) :
      null,
      nickname:  await grabChatterNickname(x.chatter!.id!, context),
      date: x.date!
    ));
    final l = await Future.wait(likesAsDto.map((x) async => x.then((i) => i)).toList());
    l.sort((a, b) => a.date.compareTo(b.date));
    return Response.ok(json.encode(l.map((x) => x.toJson()).toList()));
  }
}
