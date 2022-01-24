import 'package:conduit/conduit.dart';
import 'dart:async';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/message.dart';
import 'dart:convert';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:backend/models/msg.dart';
class ProfileController extends ResourceController {
	ManagedContext context;
	ProfileController(this.context);
	@Operation.get('jwt')
	Future<Response> get(@Bind.path('jwt') String jwt) async {
		final decryptorQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(request!.authorization!.ownerID);
		final decryptor = await decryptorQuery.fetchOne();
		final qrId = verifyJwtHS256Signature(jwt, decryptor!.secret!);
		final chatterQuery = Query<Chatter>(context)
			..where((i) => i.qrId).equalTo(qrId['id']);
		final chatter = await chatterQuery.fetchOne();
		final incomingMessagesQuery = Query<Message>(context)
			..where((i) => i.to?.id).equalTo(chatter?.id)
			..sortBy((u) => u.date, QuerySortOrder.ascending);
		final incomingMessages = await incomingMessagesQuery.fetch();
		final outgoingMessagesQuery = Query<Message>(context)
			..where((i) => i.from?.id).equalTo(chatter?.id)
			..sortBy((u) => u.date, QuerySortOrder.ascending);
		final outgoingMessages = await outgoingMessagesQuery.fetch();
		final List<Msg> incomings = [];
		for (Message incoming in incomingMessages) {
			incomings.add(Msg(value: incoming!.value!, date: incoming!.date!));
		}
		final List<Msg> outgoings = [];
		for (Message outgoing in outgoingMessages) {
			outgoings.add(Msg(value: outgoing!.value!, date: outgoing!.date!));
		}
		return Response.ok({
			"incoming": json.encode(incomings.map((x) => x!.toJson()).toList()),
			"outgoing": json.encode(outgoings.map((x) => x!.toJson()).toList())
		});
	}
}
