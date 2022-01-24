import 'package:conduit/conduit.dart';
import 'package:backend/models/following.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';

Future<Tuple2<int, int>> getInnerFollow(ManagedContext context, Following follower) async {
	final innerFollowersQuery = Query<Following>(context)
		..where((i) => i.id).equalTo(follower?.chatter?.id!);
	final List<Following> innerFollowers = await innerFollowersQuery.fetch();
	final innerFollowingQuery = Query<Following>(context)
		..where((i) => i.id).equalTo(follower?.follower?.id!);
	final List<Following> innerFollowing = await innerFollowingQuery.fetch();
	return Tuple2<int, int>(innerFollowers.length, innerFollowing.length);	
}

