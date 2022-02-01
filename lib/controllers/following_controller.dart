import 'package:conduit/conduit.dart';
import 'package:backend/models/following.dart';
import 'dart:async';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/follower.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'dart:convert';
import 'package:tuple/tuple.dart';

class FollowingController extends ResourceController {
	ManagedContext context;
	FollowingController(this.context);

	@Operation.post('id')
	Future<Response> follow(@Bind.path('id') String id) async {
		final Map<String, dynamic> body = await request!.body.decode();
		if(body['nickname'] == null) {
			return Response.badRequest(body: {
				"error": "please give the one you will follow a nickname"
			});
		}
		final chatterQuery = Query<Chatter>(context)
			..where((i) => i.qrId).equalTo(id);
		final chatter = await chatterQuery.fetchOne();
		print(chatter?.id);
		final followerQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(request?.authorization?.ownerID);
		final follower = await followerQuery.fetchOne();
		print(follower?.id);
		final query = Query<Following>(context)
			..where((i) => i.chatter?.id).equalTo(chatter?.id)
			..where((i) => i.follower?.id).equalTo(follower?.id);
		final check = await query.fetchOne();
		if(check != null) return Response.badRequest();
		final followingQuery = Query<Following>(context)
			..values.follower = follower
			..values.chatter = chatter;
		await followingQuery.insert();
		return Response.ok("");
	}
	@Operation.get('id')
	Future<Response> followers(@Bind.path('id') String id) async {
		final chatterQuery = Query<Chatter>(context)
				..where((i) => i.qrId).equalTo(id);
		final chatter = await chatterQuery.fetchOne();
		final followingQuery = Query<Following>(context)
			..where((i) => i.chatter?.id).equalTo(chatter?.id);
		final followers = await followingQuery.fetch();
		List<Follower> flws = [];
		for (Following follower in followers) {
			final foscholloschowescherQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(follower.follower?.id);
			final foscholloschowescher = await foscholloschowescherQuery.fetchOne();
			final claim = JwtClaim(otherClaims: <String, String>{
				'id': foscholloschowescher!.qrId!
			});
			final token = issueJwtHS256(claim, chatter!.secret!);
			final innerFollowersQuery = Query<Following>(context)
				..where((i) => i.chatter?.id).equalTo(follower.follower?.id!);
			final List<Following> innerFollowers = await innerFollowersQuery.fetch();
			final innerFollowingQuery = Query<Following>(context)
				..where((i) => i.follower?.id).equalTo(follower.follower?.id!);
			final List<Following> innerFollowing = await innerFollowingQuery.fetch();
			flws.add(Follower(
				nickname: foscholloschowescher.nickname!,
				personalNickname: null, encryptedId:
				token, followers: innerFollowers.length,
				following: innerFollowing.length));
		};
		return Response.ok(json.encode(flws.map((f) => f.toJson()).toList()));
	}
	@Operation.get()
	Future<Response> following() async {
		final followingQuery = Query<Following>(context)
			..where((i) => i.follower?.id).equalTo(request!.authorization!.ownerID);
		final List<Following> follow_ing = await followingQuery.fetch();
		final chaschatQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(request!.authorization!.ownerID);
		final chaschat = await chaschatQuery.fetchOne();
		List<Follower> flws = [];
		for (Following follower in follow_ing) {
			final chatterQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(follower.chatter?.id);
			Chatter? chatter = await chatterQuery.fetchOne();
			final claim = JwtClaim(otherClaims: <String, String>{
				'id': chatter!.qrId!
			});
			final String token = issueJwtHS256(claim, chaschat!.secret!);
			final innerFollowersQuery = Query<Following>(context)
				..where((i) => i.chatter?.id).equalTo(follower.chatter?.id!);
			final List<Following> innerFollowers = await innerFollowersQuery.fetch();
			final innerFollowingQuery = Query<Following>(context)
				..where((i) => i.follower?.id).equalTo(follower.chatter?.id!);
			final List<Following> innerFollowing = await innerFollowingQuery.fetch();
			flws.add(Follower(
				nickname: chatter.nickname!,
				encryptedId: token,
				followers: innerFollowers.length,
				following: innerFollowing.length
			));
		}
		return Response.ok(json.encode(flws.map((f) => f.toJson()).toList()));
	}
}
