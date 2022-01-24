import 'package:conduit/conduit.dart';
import 'dart:async';
import 'package:backend/models/profile_follow.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/following.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'dart:convert';
class ProfileFollowingController extends ResourceController {
	ManagedContext context;
	ProfileFollowingController(this.context);

	@Operation.get('jwt')
	Future<Response> following(@Bind.path('jwt') String jwt) async {
		final decryptorQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(request!.authorization!.ownerID);
		final decryptor = await decryptorQuery.fetchOne();
		final JwtClaim claim = verifyJwtHS256Signature(jwt, decryptor!.secret!);		
		final chatterQuery = Query<Chatter>(context)
			..where((i) => i.qrId).equalTo(claim['id']!);
		final chatter = await chatterQuery.fetchOne();
		final followerQuery = Query<Following>(context)
			..where((i) => i.follower!.id).equalTo(chatter?.id);
		final followers = await followerQuery.fetch();
		List<ProfileFollow> pefw = [];
		for (Following following in followers) {
			final doesFollowDecryptorQuery = Query<Following>(context)
				..where((i) => i.chatter!.id).equalTo(request!.authorization!.ownerID)
				..where((i) => i.follower!.id).equalTo(following.follower!.id);
			final doesFollowDecryptor = await doesFollowDecryptorQuery.fetchOne();
			final doesDecryptorFollowQuery = Query<Following>(context)
				..where((i) => i.follower!.id).equalTo(request!.authorization!.ownerID)
				..where((i) => i.chatter!.id).equalTo(following.follower!.id);
			final doesDecryptorFollow = await doesDecryptorFollowQuery.fetchOne();
			final nicknameQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(following?.chatter?.id);
			final nickname = await nicknameQuery.fetchOne();
			if (doesFollowDecryptor == null && doesDecryptorFollow == null) {
				pefw.add(ProfileFollow(mutual: false, nickname: nickname!.nickname!));
			} else {
				pefw.add(ProfileFollow(mutual: true, nickname: nickname!.nickname!));
			}
		}
		return Response.ok(json.encode(pefw.map((x) => x.toJson()).toList()));

	}
}
