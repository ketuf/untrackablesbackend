import 'package:conduit/conduit.dart';
import 'dart:async';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/msg.dart';
import 'dart:convert';
import 'package:backend/helpers/extract_token.dart';
class ChatController extends ResourceController {
	ManagedContext context;
	String secret;
	ChatController(this.context, this.secret);

	@Operation.post()
	Future<Response> fetchMessage() async {
		final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
		final Map<String, dynamic> body = await request!.body.decode();
		final message = body['message'] as String;
		if(message.isEmpty) {
			return Response.badRequest(body: {
				"error": "cannot send empty message"
			});
		}
		final fromChatterQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(ischid);
		final fromChatter = await fromChatterQuery.fetchOne();
		final JwtClaim claim = verifyJwtHS256Signature(body['to'] as String, fromChatter!.secret!);
		final to = claim['id'] as String;
		final toChatterQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(to);
		final toChatter = await toChatterQuery.fetchOne();
		final msg = Query<Message>(context)
			..values.from = fromChatter
			..values.to = toChatter
			..values.date = DateTime.now()
			..values.isPrivate = body['isPrivate'] as bool
			..values.value = message;
		final mesches = await msg.insert();
		return Response.ok("");
	}
	@Operation.get('to')
	Future<Response> getMessages(@Bind.path('to') String to) async {
		final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
		final decryptorQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(ischid);
		final decryptor = await decryptorQuery.fetchOne();
		final toQr = verifyJwtHS256Signature(to, decryptor!.secret!);
		final recieverQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(toQr['id']! as String);
		final reciever = await recieverQuery.fetchOne();
		final ourMessagesQuery = Query<Message>(context)
			..where((i) => i.from?.id).equalTo(decryptor.id)
			..where((i) => i.to?.id).equalTo(reciever?.id);
		final List<Message> ourMessages = await ourMessagesQuery.fetch();
		final otherMessagesQuery = Query<Message>(context)
			..where((i) => i.from?.id).equalTo(reciever?.id)
			..where((i) => i.to?.id).equalTo(decryptor.id);
		final List<Message> otherMessages = await otherMessagesQuery.fetch();
		List<Message> messages = [];
		messages.addAll(ourMessages);
		messages.addAll(otherMessages);
		List<Msg> msgs = [];
		for(Message msg in messages) {
			if (msg.from?.id == ischid) {
				msgs.add(Msg(ours: true, value: msg.value!, date: msg.date!));
			} else {
				msgs.add(Msg(ours: false, value: msg.value!, date: msg.date!));
			}
		}
		msgs.sort((a, b) => a.date.compareTo(b.date));
		return Response.ok(json.encode(msgs.map((x) => x.toJson()).toList()));
	}
}
