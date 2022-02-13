import 'package:backend/models/chatter.dart';
import 'package:conduit/conduit.dart';


Future<String> grabChatterNickname(String id, ManagedContext context) async {
  final chatterQuery = Query<Chatter>(context)
    ..where((i) => i.id).equalTo(id);
  final chatter = await chatterQuery.fetchOne();
  return chatter!.nickname!;
}
