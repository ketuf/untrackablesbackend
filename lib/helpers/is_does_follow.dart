import 'package:conduit/conduit.dart';
import 'package:backend/models/following.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
import 'package:backend/models/chatter.dart';

Future<Tuple2<bool, bool>> isDoesFollow(ManagedContext context, String id, String ourId) async {
	final followingQuery = Query<Following>(context);
	final List<Following> following = await followingQuery.fetch();
	final isFollowed = following.any((i) => i.chatter?.id == ourId && i.follower?.id == id);
	final doesFollow = following.any((i) => i.chatter?.id == id && i.follower?.id == ourId);

	return Tuple2<bool, bool>(isFollowed, doesFollow);
}
