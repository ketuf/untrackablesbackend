import 'package:conduit/conduit.dart';
import 'package:backend/models/following.dart';
import 'package:backend/models/chatter.dart';
import 'dart:async';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:backend/models/profile_follow.dart';
import 'dart:convert';
class ProfileFollowersController extends ResourceController {
  ManagedContext context;
  ProfileFollowersController(this.context);

  @Operation.get('jwt')
  Future<Response> getProfileFollowers(@Bind.path('jwt') String jwt) async {
    final decryptorQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID!);
    final decryptor = await decryptorQuery.fetchOne();
    final JwtClaim claim = verifyJwtHS256Signature(jwt, decryptor!.secret!);
    final chatterQuery = Query<Chatter>(context)
      ..where((i) => i.qrId).equalTo(claim['id']! as String);
    final chatter = await chatterQuery.fetchOne();
    final followingQuery = Query<Following>(context)
      ..where((i) => i.chatter?.id).equalTo(chatter?.id);
    final following = await followingQuery.fetch();

    final chattersJwtFollowing = following.map((f) => f.follower?.id).toList();
    final allQuery = Query<Following>(context);
    final List<Following> all = await allQuery.fetch();
    final Map<int, bool> maschap = Map();
    for (Following f in following) {
      maschap[f.id!] = false;
    }
    for (Following flws in all.where((a) => chattersJwtFollowing.contains(a.follower?.id))) {
      if (maschap.containsKey(flws.id!)) {
        if(flws.chatter?.id == request!.authorization?.ownerID || flws.follower?.id == request!.authorization?.ownerID) {
            maschap[flws.id!] = true;
        } else {
          maschap[flws.id!] = false;
        }
      } else {
          if(all.where((e) => e.follower?.id == flws.follower?.id && e.chatter?.id == chatter?.id).isNotEmpty) {
              Following flwid = all.singleWhere((e) => e.follower?.id == flws.follower?.id && e.chatter?.id == chatter?.id);
              if (maschap.containsKey(flwid.id!)) {
                maschap[flwid.id!] = true;
              }
              if (all.where((e) => e.follower?.id == flws.chatter?.id && e.chatter?.id == chatter?.id).isNotEmpty) {
                Following flwid = all.singleWhere((e) => e.follower?.id == flws.chatter?.id && e.chatter?.id == chatter?.id);
                if (maschap.containsKey(flwid.id!)) {
                  maschap[flwid.id!] = true;
                }
              }
          }
      }
    }
    for (Following flws in all.where((a) => chattersJwtFollowing.contains(a.chatter?.id)))
    if (maschap.containsKey(flws.id!)) {
      if(flws.chatter?.id == request!.authorization?.ownerID || flws.follower?.id == request!.authorization?.ownerID) {
          maschap[flws.id!] = true;
      } else {
        maschap[flws.id!] = false;
      }
    } else {
        if(all.where((e) => e.follower?.id == flws.follower?.id && e.chatter?.id == chatter?.id).isNotEmpty) {
            Following flwid = all.singleWhere((e) => e.follower?.id == flws.follower?.id && e.chatter?.id == chatter?.id);
            if (maschap.containsKey(flwid.id!)) {
              maschap[flwid.id!] = true;
            }
            if (all.where((e) => e.follower?.id == flws.chatter?.id && e.chatter?.id == chatter?.id).isNotEmpty) {
              Following flwid = all.singleWhere((e) => e.follower?.id == flws.chatter?.id && e.chatter?.id == chatter?.id);
              if (maschap.containsKey(flwid.id!)) {
                maschap[flwid.id!] = true;
              }
            }
        }
    }
    List<ProfileFollow> pefw = [];
    for (int key in maschap.keys) {
      Following flwg = all.singleWhere((e) => e.id! == key);
      final nicknameQuery = Query<Chatter>(context)
        ..where((i) => i.id).equalTo(flwg.follower?.id!);
      final nickname = await nicknameQuery.fetchOne();
	  final claim = JwtClaim(otherClaims: <String, String>{
		'id': nickname!.qrId!
	  });
	  final token = issueJwtHS256(claim, decryptor.secret!);
      pefw.add(ProfileFollow(mutual: maschap[key]!, nickname: nickname!.nickname!, encryptedId: token));
    }
    return Response.ok(json.encode(pefw.map((x) => x.toJson()).toList()));
  }
}
