import 'package:conduit/conduit.dart';
import 'dart:async';
import 'package:backend/models/profile_follow.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/following.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'dart:convert';
import 'package:backend/helpers/extract_token.dart';
class ProfileFollowingController extends ResourceController {
	ManagedContext context;
	String secret;
	ProfileFollowingController(this.context, this.secret);

	@Operation.get('jwt')
	Future<Response> following(@Bind.path('jwt') String jwt) async {
		final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
		final decryptorQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(ischid);
		final decryptor = await decryptorQuery.fetchOne();
		final JwtClaim claim = verifyJwtHS256Signature(jwt, decryptor!.secret!);
		final chatterQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(claim['id']! as String);
		final chatter = await chatterQuery.fetchOne();
		final followerQuery = Query<Following>(context)
			..where((i) => i.follower?.id).equalTo(chatter?.id);
		final followers = await followerQuery.fetch();

		final chattersJwtFollows = followers.map((f) => f.chatter?.id!).toList();
		final allQuery = Query<Following>(context);
		final List<Following> all = await allQuery.fetch();
		final Map<int, bool> maschap = Map();
		for (Following f in followers) {
			maschap[f.id!] = false;
		}
		for (Following flws in all.where((a) => chattersJwtFollows.contains(a.chatter?.id!))) {
			if (maschap.containsKey(flws.id!)) {
					if(flws.chatter?.id == ischid || flws.follower?.id == ischid) {
							maschap[flws.id!] = true;
					} else {
						maschap[flws.id!] = false;
					}
			} else {
					if(all.where((e) => e.chatter?.id == flws.chatter?.id && e.follower?.id == chatter?.id).isNotEmpty) {
						Following flwid = all.singleWhere((e) => e.chatter?.id == flws.chatter?.id  && e.follower?.id == chatter?.id);
						if (maschap.containsKey(flwid.id!)) {
								maschap[flwid.id!] = true;
						}
						if (all.where((e) => e.chatter?.id == flws.follower?.id && e.follower?.id == chatter?.id).isNotEmpty) {
						Following flwid = all.singleWhere((e) => e.chatter?.id == flws.follower?.id && e.follower?.id == chatter?.id);
						if (maschap.containsKey(flwid.id!)) {
								maschap[flwid.id!] = true;
						}
					}
				}
			}
		}
		for (Following flws in all.where((a) => chattersJwtFollows.contains(a.follower?.id))) {
			print('flwsid');
			print(flws.id);
				if (maschap.containsKey(flws.id!)) {
						if(flws.chatter?.id == ischid || flws.follower?.id == ischid) {
								maschap[flws.id!] = true;
						} else {
							maschap[flws.id!] = false;
						}
				} else {
					print('gothereeeeee');
					print(flws.follower?.id);
						if(all.where((e) => e.chatter?.id == flws.chatter?.id && e.follower?.id == chatter?.id).isNotEmpty) {
							Following flwid = all.singleWhere((e) => e.chatter?.id == flws.chatter?.id  && e.follower?.id == chatter?.id);
							if (maschap.containsKey(flwid.id!)) {
									maschap[flwid.id!] = true;
							}
						}
						if (all.where((e) => e.follower?.id == chatter?.id && e.chatter?.id == flws.follower?.id).isNotEmpty) {
							print('gaschathescheresche');
							Following flwid = all.singleWhere((e) => e.follower?.id == chatter?.id && e.chatter?.id == flws.follower?.id);
							if (maschap.containsKey(flwid.id!)) {
								print('komopdan');
									maschap[flwid.id!] = true;
							}
						}
				}
		}
		List<ProfileFollow> pefw = [];
		for (int key in maschap.keys) {
			Following flwg = all.singleWhere((e) => e.id! == key);
			final nicknameQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(flwg.chatter?.id!);
			final nickname = await nicknameQuery.fetchOne();
			final claim = JwtClaim(otherClaims: <String, String>{
				'id': nickname!.id!
			});
			final token = issueJwtHS256(claim, decryptor.secret!);
			pefw.add(ProfileFollow(mutual: maschap[key]!, nickname: nickname.nickname!, encryptedId: token));
		}
		return Response.ok(json.encode(pefw.map((x) => x.toJson()).toList()));
	}
}
