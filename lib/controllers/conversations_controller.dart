import 'package:conduit/conduit.dart';
import 'dart:async';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/message_dto.dart';
import 'package:tuple/tuple.dart';
import 'dart:convert';
import 'package:backend/helpers/encrypt.dart';
import 'package:backend/helpers/grab_chatter.dart';
class ConversationsController extends ResourceController {
  ManagedContext context;
  ConversationsController(this.context);

  @Operation.get()
  Future<Response> get() async {
    final messagesQuery = Query<Message>(context)
    		..sortBy((u) => u.date, QuerySortOrder.ascending);
    final messages = await messagesQuery.fetch();
    final ourMessages = messages.where((m) => m.from!.id! == request!.authorization!.ownerID || m.to!.id! == request!.authorization!.ownerID);
    final List<int> strangers = [];
    ourMessages.where((e) => !strangers.contains(e.from?.id) && e.from?.id != request!.authorization!.ownerID).forEach((e) => strangers.add(e.from!.id!));
    ourMessages.where((e) => !strangers.contains(e.to?.id) && e.to?.id != request!.authorization!.ownerID).forEach((e) => strangers.add(e.to!.id!));
    final List<List<Future<MessageDto>>> msgs = [[]];
    final cryptorQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final cryptor = await cryptorQuery.fetchOne();
    for(int i = 0; i < strangers.length; i++)  {
		msgs[i].addAll(
		        ourMessages.where(
	    	      (e) => e.to?.id == strangers[i] || e.from?.id == strangers[i]
	       	 ).map(
	        	  (x) async => MessageDto(
	             ours: true,
	           	 value: x.value!, date: x.date!,
	           	 encryptedId: x.from?.id == request!.authorization!.ownerID ?
               eschencryschypt(await grabChatterQrId(x.to!.id!, context), cryptor!.secret!) :
               eschencryschypt(await grabChatterQrId(x.from!.id!, context), cryptor!.secret!),
	           	 toFrom: x.from?.id ==  request!.authorization!.ownerID ? await grabChatterNickname(x.to!.id!, context) :
               await grabChatterNickname(x.to!.id!, context)
	          )
	        )
	      );
    }
    final k = await Future.wait(msgs.map((inner) async => await Future.wait(inner.map((x) => x.then((r) => r.toJson())).toList())).toList());
    return Response.ok(json.encode(k));
  }
}
