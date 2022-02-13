import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/comment.dart';
import 'package:backend/helpers/extract_token.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/comments_dto.dart';
import 'package:backend/helpers/encrypt.dart';
import 'dart:convert';
class CommentsController extends ResourceController {
    ManagedContext ctx;
    String secret;
    CommentsController(this.ctx, this.secret);

    @Operation.post()
    Future<Response> fetchComment() async {
      final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
      final chatterQuery = Query<Chatter>(ctx)
        ..where((i) => i.id).equalTo(ischid);
      final chatter = await chatterQuery.fetchOne();
      final Map<String, dynamic> body = await request!.body.decode();
      final messageQuery = Query<Message>(ctx)
        ..where((i) => i.id).equalTo(body['msgId'] as int);
      final message = await messageQuery.fetchOne();
      final commentQuery = Query<Comment>(ctx)
        ..values.chatter = chatter
        ..values.message = message
        ..values.value = body['value'] as String
        ..values.date = DateTime.now();
      final comment = await commentQuery.insert();
      return Response.ok("");
    }
    @Operation.get('id')
    Future<Response> getComments(@Bind.path('id') int id) async {
      final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
      final cryptorQuery = Query<Chatter>(ctx)
        ..where((i) => i.id).equalTo(ischid);
      final cryptor = await cryptorQuery.fetchOne();
      final commentsQuery = Query<Comment>(ctx)
        ..where((i) => i.message?.id).equalTo(id)
        ..sortBy((u) => u.date, QuerySortOrder.ascending);
;
      final comments = await commentsQuery.fetch();
      final cdtol = comments.map((x) => CommentDto(
        value: x.value!,
        date: x.date!,
        encryptedId: eschencryschypt(x.chatter!.id!, cryptor!.secret!)
      ));
      return Response.ok(json.encode(cdtol.map((c) => c.toJson()).toList()));
    }
}
