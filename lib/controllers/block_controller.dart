import 'package:conduit/conduit.dart';
import 'package:backend/models/following.dart';
import 'package:backend/helpers/extract_token.dart';
import 'package:backend/models/chatter.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:backend/backend.dart';
import 'dart:async';
import 'package:random_string/random_string.dart';

class BlockController extends ResourceController {
  ManagedContext context;
  String secret;
  BlockController(this.context, this.secret);

  @Operation.delete('jwt')
  Future<Response> block(@Bind.path('jwt') String jwt) async {
    final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
    final decryptorQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(ischid);
    final decryptor = await decryptorQuery.fetchOne();
    final followersQuery = Query<Following>(context)
      ..where((i) => i.chatter?.id).equalTo(ischid);
    final followers = await followersQuery.fetch();
    final JwtClaim claim = verifyJwtHS256Signature(jwt, decryptor!.secret!);
    final toDeleteId = claim['id'] as String;
    if(followers.any((i) => i.follower?.id == toDeleteId)) {
      Following flws = followers.singleWhere((f) => f.follower?.id == toDeleteId);
      final flwsDeleteQuery = Query<Following>(context)
        ..where((i) => i.id).equalTo(flws.id!);
      await flwsDeleteQuery.delete();
    }
    final followingQuery = Query<Following>(context)
      ..where((i) => i.follower?.id).equalTo(ischid);
    final following = await followingQuery.fetch();
    if(following.any((f) => f.chatter?.id == toDeleteId)) {
      Following flwg = following.singleWhere((i) => i.chatter?.id == toDeleteId);
      final flwgDeleteQuery = Query<Following>(context)
        ..where((i) => i.id).equalTo(flwg.id);
      await flwgDeleteQuery.delete();
    }
    print('oka');
    final deleteQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(ischid);
    await deleteQuery.delete();
    final newChatterQuery = Query<Chatter>(context)
      ..values.id = randomAlphaNumeric(1000)
      ..values.password = decryptor.password
      ..values.nickname = decryptor.nickname
      ..values.isConfirmedEmail = decryptor.isConfirmedEmail
      ..values.phonenumber = decryptor.phonenumber
      ..values.phonenumberConfirmToken = decryptor.phonenumberConfirmToken
      ..values.isConfirmedPhonenumber = decryptor.isConfirmedPhonenumber
      ..values.secret = decryptor.secret;
    final newChatter = await newChatterQuery.insert();
    print('oke');
    final toUpdateFollowersQuery = Query<Following>(context)
      ..values.chatter = newChatter
      ..where((i) => i.chatter?.id).equalTo(ischid);
    final updatedFollowers = await toUpdateFollowersQuery.update();
    final toUpdateFollowingQuery = Query<Following>(context)
      ..values.follower = newChatter
      ..where((i) => i.follower?.id).equalTo(ischid);
    final updatedFollowing = await toUpdateFollowingQuery.update();
    
    return Response.ok("");
  }
}
