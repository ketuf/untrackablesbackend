import 'package:conduit/conduit.dart';
import 'dart:async';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/message.dart';
import 'dart:convert';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:backend/models/msg.dart';
import 'package:backend/models/following.dart';
import 'package:backend/helpers/is_does_follow.dart';
import 'package:tuple/tuple.dart';
import 'package:backend/helpers/messages.dart';
import 'package:backend/helpers/extract_token.dart';
class ProfileController extends ResourceController {
	ManagedContext context;
	String secret;
	ProfileController(this.context, this.secret);
	@Operation.get('jwt')
	Future<Response> get(@Bind.path('jwt') String jwt) async {
		final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
		final decryptorQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(ischid);
		final decryptor = await decryptorQuery.fetchOne();
		final qrId = verifyJwtHS256Signature(jwt, decryptor!.secret!);
		final chatterQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(qrId['id'] as String);
		final chatter = await chatterQuery.fetchOne();
		final Tuple2<List<Message>, List<Message>> msgs = await getMessages(context, chatter!.id!);


		final List<Msg> incomings = [];
		for (Message incoming in msgs.item1) {
			final fromQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(incoming.from?.id!);
			final from = await fromQuery.fetchOne();

			Tuple2<bool, bool> isDoesFollowing = await isDoesFollow(context, from!.id!, ischid);
			if(!isDoesFollowing.item1 && !isDoesFollowing.item2) {
				incomings.add(Msg(isMutual: false, value: incoming.value!, date: incoming.date!, toFrom: from.nickname!));
			} else {
				final claim = JwtClaim(otherClaims: <String, String>{
					'id': from.id!
				});
				final token = issueJwtHS256(claim, decryptor.secret!);
				incomings.add(Msg(
					isMutual: true,
					encryptedId: token,
					value: incoming.value!,
					date: incoming.date!,
					toFrom: from.nickname!
				));
			}
		}
		final List<Msg> outgoings = [];
		for (Message outgoing in msgs.item2) {
			final toQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(outgoing.to?.id!);
			final to = await toQuery.fetchOne();
			Tuple2<bool, bool> isDoesFollowing = await isDoesFollow(context, to!.id!, ischid);
			if(!isDoesFollowing.item1 && !isDoesFollowing.item2) {
				outgoings.add(Msg(isMutual: false, value: outgoing.value!, date: outgoing.date!, toFrom: to.nickname! ));
			} else {
				final claim = JwtClaim(otherClaims: <String, String>{
					'id': to.id!
				});
				final token = issueJwtHS256(claim, decryptor.secret!);
				outgoings.add(Msg(
					isMutual: true,
					encryptedId: token,
					value: outgoing.value!,
					date: outgoing.date!,
					toFrom: to.nickname!
				));
			}
		}
				return Response.ok({
			"incoming": json.encode(incomings.map((x) => x.toJson()).toList()),
			"outgoing": json.encode(outgoings.map((x) => x.toJson()).toList())
		});
	}
	@Operation.get()
	Future<Response> getHome() async {
		final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
		final chatterQuery = Query<Chatter>(context)
			..where((i) => i.id).equalTo(ischid);
		final chatter = await chatterQuery.fetchOne();
		Tuple2<List<Message>, List<Message>> msgs = await getMessages(context, chatter!.id!);
		List<Msg> incomings = [];
		for (Message incoming in msgs.item1) {
			final fromQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(incoming.from?.id);
			final from = await fromQuery.fetchOne();
			final claim = JwtClaim(otherClaims: <String, String>{
				'id': from!.id!
			});
			final token = issueJwtHS256(claim, chatter.secret!);
			incomings.add(Msg(encryptedId: token, value: incoming.value!, date: incoming.date!, toFrom: from.nickname));
		}
		List<Msg> outgoings = [];
		for(Message outgoing in msgs.item2) {
			final toQuery = Query<Chatter>(context)
				..where((i) => i.id).equalTo(outgoing.to?.id);
			final to = await toQuery.fetchOne();
			final claim = JwtClaim(otherClaims: <String, String>{
				'id': to!.id!
			});
			final token = issueJwtHS256(claim, chatter.secret!);
			outgoings.add(Msg(encryptedId: token, value: outgoing.value!, date: outgoing.date!, toFrom: to.nickname));
		}
		return Response.ok({
			"incoming": json.encode(incomings.map((x) => x.toJson()).toList()),
			"outgoing": json.encode(outgoings.map((x) => x.toJson()).toList())
		});
	}
}
