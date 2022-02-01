import 'package:tuple/tuple.dart';
import 'package:conduit/conduit.dart';
import 'package:backend/models/following.dart';
Future<Tuple2<List<int>, List<int>>> grabFollowersFollowing(int id, ManagedContext context) async{
  final followingQuery = Query<Following>(context)
    ..where((i) => i.follower?.id).equalTo(id);
  final following = await followingQuery.fetch();
  final followersQuery = Query<Following>(context)
    ..where((i) => i.chatter?.id).equalTo(id);
  final followers = await followersQuery.fetch();
  return Tuple2<List<int>, List<int>>(
    following.map((x) => x.chatter!.id!).toList(),
    followers.map((x) => x.follower!.id!).toList()
  );
}
