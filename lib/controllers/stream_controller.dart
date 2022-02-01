import 'dart:convert';
import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'dart:async';
import 'package:backend/models/following.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/msg_stream.dart';
import 'package:backend/helpers/grab_chatter.dart';
import 'package:backend/helpers/encrypt.dart';
class StreamController extends ResourceController {
  ManagedContext context;
  StreamController(this.context);
  @Operation.get()
  Future<Response> get() async {
    final cryptorQuery = Query<Chatter>(context)
      ..where((i) => i.id).equalTo(request!.authorization!.ownerID);
    final cryptor = await cryptorQuery.fetchOne();
    final followingQuery = Query<Following>(context)
      ..where((i) => i.follower?.id).equalTo(request!.authorization!.ownerID);
    final following = await followingQuery.fetch();
    final followersQuery = Query<Following>(context)
      ..where((i) => i.chatter?.id).equalTo(request!.authorization!.ownerID);
    final followers = await followersQuery.fetch();
    final flwgIds = following.map((x) => x.chatter?.id!);
    final flwsIds = followers.map((x) => x.follower?.id!);
    final List<Future<MsgStream>> incoming = [];
    final List<Future<MsgStream>> outgoing = [];
    for(Following flwg in following) {
        final msgIncomingFollowingQuery = Query<Message>(context)
          ..where((i) => i.to?.id).equalTo(flwg.chatter?.id);
        final msgIncomingFollowing = await msgIncomingFollowingQuery.fetch();
        final msgIncomingUsQuery = Query<Message>(context)
          ..where((i) => i.to?.id).equalTo(request!.authorization!.ownerID);
        final msgIncomingUs = await msgIncomingUsQuery.fetch();
        incoming.addAll(
          msgIncomingFollowing.map(
            (m) async => MsgStream(
              isUs: false,
              isFromMutual: flwgIds.contains(m.from?.id) || flwsIds.contains(m.from?.id),
              isToMutual: true,
              msgId: m.id!,
              from: await grabChatterNickname(m.from!.id!, context),
              fromEncryptedId: (flwgIds.contains(m.from?.id) || flwsIds.contains(m.from?.id)) ? eschencryschypt(await grabChatterQrId(m.from!.id!, context), cryptor!.secret!) : null,
              to: await grabChatterNickname(m.to!.id!, context),
              toEncryptedId: eschencryschypt(await grabChatterQrId(m.to!.id!, context), cryptor!.secret!),
              date: m.date!,
              value: m.value!
            )
          )
        );
        incoming.addAll(
          msgIncomingUs.map(
            (m) async => MsgStream(
              isUs: true,
              isFromMutual: true,
              isToMutual: false,
              msgId: m.id!,
              from: await grabChatterNickname(m.from!.id!, context),
              fromEncryptedId: eschencryschypt(await grabChatterQrId(m.from!.id!, context), cryptor!.secret!),
              to: null,
              toEncryptedId: null,
              date: m.date!,
              value: m.value!
            )
          )
        );
        final msgOutgoingFollowingQuery = Query<Message>(context)
          ..where((i) => i.from?.id).equalTo(flwg.chatter?.id);
        final msgOutgoingFollowing = await msgOutgoingFollowingQuery.fetch();
        final msgOutgoingUsQuery = Query<Message>(context)
          ..where((i) => i.from?.id).equalTo(request!.authorization!.ownerID);
        final msgOutgoingUs = await msgOutgoingUsQuery.fetch();
        outgoing.addAll(
          msgOutgoingFollowing.map(
            (x) async => MsgStream(
              isUs: false,
              isFromMutual: true,
              msgId: x.id!,
              fromEncryptedId: eschencryschypt(await grabChatterQrId(x.from!.id!, context), cryptor!.secret!),
              from: await grabChatterNickname(x.from!.id!, context),
              isToMutual: flwgIds.contains(x.to!.id!) || flwsIds.contains(x.to!.id!),
              to: await grabChatterNickname(x.to!.id!, context),
              toEncryptedId: (flwgIds.contains(x.to!.id!) || flwsIds.contains(x.to!.id!)) ? eschencryschypt(await grabChatterQrId(x.to!.id!, context), cryptor!.secret!) : null,
              date: x.date!,
              value: x.value!
            )
        ));
        outgoing.addAll(
          msgOutgoingUs.map(
            (x) async => MsgStream(
              isUs: true,
              isFromMutual: false,
              isToMutual: true,
              msgId: x.id!,
              from: null,
              fromEncryptedId: null,
              to: await grabChatterNickname(x.to!.id!, context),
              toEncryptedId: eschencryschypt(await grabChatterQrId(x.to!.id!, context), cryptor!.secret!),
              value: x.value!,
              date: x.date!,
            )
          )
        );
        }
        final ischin = await Future.wait(incoming.map((x) async =>  x.then((i) => i)).toList());
        ischin.sort((a, b) => a.date.compareTo(b.date));
        final oschout = await Future.wait(outgoing.map((x) async => x.then((i) => i)).toList());
        oschout.sort((a, b) => a.date.compareTo(b.date));
        return Response.ok({
          "incoming": json.encode(ischin.map((x) => x.toJson()).toList()),
          "outgoing": json.encode(oschout.map((y) => y.toJson()).toList())
        });



  }
}
