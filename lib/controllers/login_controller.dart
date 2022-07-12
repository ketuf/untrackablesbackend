import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class LoginController extends ResourceController {
  ManagedContext context;
  String secret;
  LoginController(this.context, this.secret);
  @Operation.post()
  Future<Response> login() async {
    final Map<String, dynamic> body = await request!.body.decode();
    final chatterQuery = Query<Chatter>(context)
      ..where((c) => c.nickname).equalTo(body['nickname'] as String);
    final chatter = await chatterQuery.fetchOne();
    if(chatter == null) {
      return Response.badRequest(body: {
        "error": "invalid username or password"
      });
    }
    if(!DBCrypt().checkpw(body['password'] as String, chatter.password!)) {
      return Response.badRequest(body: {
        "error": "invalid username or password"
      });
    }
    final claim = JwtClaim(otherClaims: <String, String>{
      'id': chatter.id!
    });
    final token = issueJwtHS256(claim, secret);
    return Response.ok(token);
  }
}
