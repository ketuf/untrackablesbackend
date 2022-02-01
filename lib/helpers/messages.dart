import 'package:backend/models/message.dart';
import 'package:tuple/tuple.dart';
import 'package:conduit/conduit.dart';
import 'dart:async';

Future<Tuple2<List<Message>, List<Message>>> getMessages(ManagedContext context, int id) async {
  	final incomingMessagesQuery = Query<Message>(context)
  		..where((i) => i.to?.id).equalTo(id)
  		..sortBy((u) => u.date, QuerySortOrder.ascending);
	final incomingMessages = await incomingMessagesQuery.fetch();
	final outgoingMessagesQuery = Query<Message>(context)
  		..where((i) => i.from?.id).equalTo(id)
  		..sortBy((u) => u.date, QuerySortOrder.ascending);
	final outgoingMessages = await outgoingMessagesQuery.fetch();
	return Tuple2<List<Message>, List<Message>>(incomingMessages, outgoingMessages);
}
