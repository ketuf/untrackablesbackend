import 'dart:convert';
import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'dart:async';
import 'package:backend/models/following.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/msg_stream.dart';
import 'package:backend/helpers/grab_chatter.dart';
import 'package:backend/helpers/encrypt.dart';
import 'package:backend/helpers/extract_token.dart';
class StreamController extends ResourceController {
  ManagedContext context;
  String secret;
  StreamController(this.context, this.secret);
  @Operation.get()
  Future<Response> get() async {
    final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
    final cryptorQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(ischid);
    final cryptor = await cryptorQuery.fetchOne();
    final followingQuery = Query<Following>(context)
      ..where((i) => i.follower?.id).equalTo(ischid);
    final following = await followingQuery.fetch();
    final followersQuery = Query<Following>(context)
      ..where((i) => i.chatter?.id).equalTo(ischid);
    final followers = await followersQuery.fetch();
    final flwgIds = following.map((x) => x.chatter?.id!);
    final flwsIds = followers.map((x) => x.follower?.id!);
    final List<Future<MsgStream>> incoming = [];
    final List<Future<MsgStream>> outgoing = [];
    final msgIncomingUsQuery = Query<Message>(context)
          ..where((i) => i.to?.id).equalTo(ischid)
          ..where((i) => i.isPrivate).equalTo(false);
    final msgIncomingUs = await msgIncomingUsQuery.fetch();
    incoming.addAll(
      msgIncomingUs.map(
        (m) async => MsgStream(
          isToMe: m.to?.id == ischid,
          isFromMe: m.from?.id == ischid,
          isFromMutual: flwgIds.contains(m.from?.id) || flwsIds.contains(m.from?.id),
          isToMutual: flwgIds.contains(m.to?.id) || flwsIds.contains(m.to?.id),
          msgId: m.id!,
          from: await grabChatterNickname(m.from!.id!, context),
          fromEncryptedId: eschencryschypt(m.from!.id!, cryptor!.secret!),
          to: await grabChatterNickname(m.to!.id!, context),
          toEncryptedId: eschencryschypt(m.to!.id!, cryptor.secret!),
          date: m.date!,
          value: m.value!
        )
      )
    );
    final msgOutgoingUsQuery = Query<Message>(context)
        ..where((i) => i.from?.id).equalTo(ischid)
        ..where((i) => i.isPrivate).equalTo(false);
    final msgOutgoingUs = await msgOutgoingUsQuery.fetch();
    outgoing.addAll(
      msgOutgoingUs.map(
        (x) async => MsgStream(
          isToMe: x.to?.id == ischid,
          isFromMe: x.from?.id == ischid,
          isFromMutual: flwgIds.contains(x.from!.id!) || flwsIds.contains(x.from!.id!),
          isToMutual: flwgIds.contains(x.to!.id!) || flwsIds.contains(x.to!.id!),
          msgId: x.id!,
          from: await grabChatterNickname(x.from!.id!, context),
          fromEncryptedId: eschencryschypt(x.from!.id!, cryptor!.secret!),
          to: await grabChatterNickname(x.to!.id!, context),
          toEncryptedId: eschencryschypt(x.to!.id!, cryptor.secret!),
          value: x.value!,
          date: x.date!,
        )
      )
    );
    for(Following flwg in following) {
        final msgIncomingFollowingQuery = Query<Message>(context)
          ..where((i) => i.to?.id).equalTo(flwg.chatter?.id)
          ..where((i) => i.isPrivate).equalTo(false);
        final msgIncomingFollowing = await msgIncomingFollowingQuery.fetch();
        
        incoming.addAll(
          msgIncomingFollowing.map(
            (m) async => MsgStream(
              isToMe: m.to?.id == ischid,
              isFromMe: m.from?.id == ischid,
              isFromMutual: flwgIds.contains(m.from?.id) || flwsIds.contains(m.from?.id),
              isToMutual: flwgIds.contains(m.to?.id) || flwsIds.contains(m.to?.id),
              msgId: m.id!,
              from: await grabChatterNickname(m.from!.id!, context),
              fromEncryptedId: (flwgIds.contains(m.from?.id) || flwsIds.contains(m.from?.id)) ? eschencryschypt(m.from!.id!, cryptor!.secret!) : null,
              to: await grabChatterNickname(m.to!.id!, context),
              toEncryptedId: eschencryschypt(m.to!.id!, cryptor!.secret!),
              date: m.date!,
              value: m.value!
            )
          )
        );
        final msgOutgoingFollowingQuery = Query<Message>(context)
          ..where((i) => i.from?.id).equalTo(flwg.chatter?.id)
          ..where((i) => i.isPrivate).equalTo(false);
        final msgOutgoingFollowing = await msgOutgoingFollowingQuery.fetch();
        outgoing.addAll(
          msgOutgoingFollowing.map(
            (x) async => MsgStream(
              isToMe: x.to?.id == ischid,
              isFromMe: x.from?.id == ischid,
              isFromMutual: flwgIds.contains(x.from!.id!) || flwsIds.contains(x.from!.id!),
              msgId: x.id!,
              fromEncryptedId: eschencryschypt(x.from!.id!, cryptor!.secret!),
              from: await grabChatterNickname(x.from!.id!, context),
              isToMutual: flwgIds.contains(x.to!.id!) || flwsIds.contains(x.to!.id!),
              to: await grabChatterNickname(x.to!.id!, context),
              toEncryptedId: (flwgIds.contains(x.to!.id!) || flwsIds.contains(x.to!.id!)) ? eschencryschypt(x.to!.id!, cryptor.secret!) : null,
              date: x.date!,
              value: x.value!
            )
        ));
        }
        final ischin = await Future.wait(incoming.map((x) async =>  x.then((i) => i)).toList());
        ischin.sort((a, b) => a.date.compareTo(b.date));
        final reschetIschin = ischin.where((element) => DateTime.parse(element.date).isAfter(DateTime.now().subtract(Duration(days: 1))));
        final oschout = await Future.wait(outgoing.map((x) async => x.then((i) => i)).toList());
        final reschetOschout = oschout.where((element) => DateTime.parse(element.date).isAfter(DateTime.now().subtract(Duration(days: 1))));
        oschout.sort((a, b) => a.date.compareTo(b.date));
        return Response.ok({
          "incoming": json.encode(reschetIschin.map((x) => x.toJson()).toList()),
          "outgoing": json.encode(reschetOschout.map((y) => y.toJson()).toList())
        });
  }
}
