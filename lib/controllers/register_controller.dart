import 'package:backend/backend.dart';
import 'package:backend/models/config.dart';
import 'package:backend/models/chatter.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:random_string/random_string.dart';
import 'package:conduit/conduit.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:dio/dio.dart' as dio;
class RegisterController extends ResourceController {
	RegisterController(this.context, this.config) {
	}
	final ManagedContext context;
	final Config config;
	@Operation.post()
	Future<Response> createChatter() async {
		final Map<String, dynamic> body = await request!.body.decode();
		String nickname = body['nickname'] as String;
		String password = body['password'] as String;
		if(!validator.password(password)) {
			return Response.badRequest(body: { 'error': 'Your password is not strong enough'});
		}
		final chatter = Query<Chatter>(context)
			..values.nickname = body['nickname'] as String
			..values.id = randomAlphaNumeric(500)
			..values.secret = randomAlphaNumeric(10)
			..values.password = DBCrypt().hashpw(password, DBCrypt().gensalt());
		final inserted = await chatter.insert();
		return Response.ok("");
	}
	// @Operation.post('token')
	// Future<Response> confirmEmail(@Bind.path('token') String token) async {
	// 	final JwtClaim claim = verifyJwtHS256Signature(token, config.secret!);
	// 	final id = claim['id'];
	// 	final chatter = Query<Chatter>(context)
	// 		..values.isConfirmedEmail = true
	// 		..where((i) => i.id).equalTo(id as String);
	// 	final updated = await chatter.updateOne();
	// 	return Response.ok("");
	// }
	// @Operation.put()
	// Future<Response> phonenumber() async {
	// 	final Map<String, dynamic> body = await request!.body.decode();
	// 	final JwtClaim claim = verifyJwtHS256Signature(body['token'] as String, config.secret!);
	// 	final id = claim['id'] as String;
	// 	final confirmation = randomNumeric(6);
	// 	print(confirmation);
	// 	final query = Query<Chatter>(context)
	// 		..where((i) => i.id).equalTo(id);
	// 	final chaschat = await query.fetchOne();
	// 	if(chaschat!.isConfirmedPhonenumber!) {
	// 		return Response.badRequest(body: {
	// 			"error": "phonenumber is already confirmed"
	// 		});
	// 	}
  //   final phonenumber = body['phonenumber'] as String;
	// 	final chatter = Query<Chatter>(context)
	// 		..values.phonenumber = phonenumber
	// 		..values.phonenumberConfirmToken = confirmation
	// 		..where((i) => i.id).equalTo(id);
	// 	final updated = await chatter.updateOne();
  //   final resches = await dio.Dio().post('https://r5mmz1.api.infobip.com/sms/2/text/advanced', data: {
  //     "messages": [
  //       {
  //         "destinations": [
  //           {
  //             "to": '$phonenumber'
  //           }
  //         ],
  //         "text": "Confirm your phonenumber with $confirmation"
  //       }
  //     ]
  //   }, options: dio.Options(
  //     headers: {
  //        'Authorization': 'App ${config.bipapikey!}'
  //     }
  //   ));
	// 	return Response.ok("");
	// }
	// @Operation.put('token')
	// Future<Response> confirmPhonenumber(@Bind.path('token') String token) async {
	// 	final Map<String, dynamic> body = await request!.body.decode();
	// 	final JwtClaim claim = verifyJwtHS256Signature(token, config.secret!);
	// 	final id = claim['id'] as String;
	// 	final chatter = Query<Chatter>(context)
	// 		..where((i) => i.id).equalTo(id);
	// 	final chaschat = await chatter.fetchOne();
	// 	if (chaschat?.phonenumberConfirmToken != body['confirmation']) {
	// 		return Response.badRequest(body: {
	// 			"error": "invalid confirmation token"
	// 		});
	// 	}
	// 	final toUpdate = Query<Chatter>(context)
	// 		..values.isConfirmedPhonenumber = true
	// 		..where((i) => i.id).equalTo(id);
	// 	final updated = await toUpdate.updateOne();
	// 	return Response.ok("");
	// }
}
