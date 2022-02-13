import 'package:conduit/conduit.dart';
import 'package:backend/models/following.dart';
import 'package:tuple/tuple.dart';
import 'dart:async';
import 'package:backend/models/chatter.dart';

Future<Tuple2<Following?, Following?>> isDoesFollow(ManagedContext context, String ourId) async {
	final isFollowedQuery = Query<Following>(context)
		..where((i) => i.chatter?.id).equalTo(ourId);
	final isFollowed = await isFollowedQuery.fetchOne();
	final doesFollowQuery = Query<Following>(context)
		..where((i) => i.follower?.id).equalTo(ourId);
	final doesFollow = await doesFollowQuery.fetchOne();
	return Tuple2<Following?, Following?>(isFollowed, doesFollow);
}
