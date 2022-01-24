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
class RegisterController extends ResourceController {
	SmtpServer? smtp;
	RegisterController(this.context, this.config, this.authServer) {
	    smtp = SmtpServer(config!.host!, port: config!.port!, username: config!.username, password: config!.password);		
	}
	final ManagedContext context;
	final Config config;
	final AuthServer authServer;
	@Operation.post()
	Future<Response> createChatter() async {
		final Map<String, dynamic> body = await request!.body.decode();
		String email = body['username'] as String;
		if(!validator.email(email)) {
			return Response.badRequest(body: { 'error': "Please enter a valid e-mail"});
		}
		String password = body['password'] as String;
		if(!validator.password(password)) {
			return Response.badRequest(body: { 'error': 'Your password is not strong enough'});
		}
		final salt = AuthUtility.generateRandomSalt();
		final chatter = Query<Chatter>(context)
			..values.username = email
			..values.nickname = body['nickname'] as String
			..values.qrId = randomAlphaNumeric(40)
			..values.secret = randomAlphaNumeric(10)
			..values.salt = salt
			..values.hashedPassword = authServer.hashPassword(password, salt); 
			
		final inserted = await chatter.insert();
		final claim = JwtClaim(otherClaims: <String, int>{
			'id': inserted.id!
		});
		final token = issueJwtHS256(claim, config.secret!);
		final message = Message()
			..from = Address(config.username!, '(un)trackabl.es')
			..recipients.add(inserted.username)
			..subject = "Please confirm your e-mail"
			..text = "Could you press on the following link to confirm your e-mail\nhttp://localhost:4200/confirm/$token";
		await send(message, smtp!);
		return Response.ok("");
	}
	@Operation.post('token')
	Future<Response> confirmEmail(@Bind.path('token') String token) async {
		final JwtClaim claim = verifyJwtHS256Signature(token, config.secret!);
		final id = claim['id'];
		final chatter = Query<Chatter>(context)
			..values.isConfirmedEmail = true
			..where((i) => i.id).equalTo(id);
		final updated = await chatter.updateOne();
		return Response.ok("");
	}
	@Operation.put()
	Future<Response> phonenumber() async {
		final Map<String, dynamic> body = await request!.body.decode();
		final JwtClaim claim = verifyJwtHS256Signature(body['token'], config.secret!);
		final id = claim['id'];
		final confirmation = randomAlphaNumeric(4);
		print(confirmation);
		final query = Query<Chatter>(context)
			..where((i) => i.id).equalTo(id);
		final chaschat = await query.fetchOne();
		if(chaschat!.isConfirmedPhonenumber!) {
			return Response.badRequest(body: {
				"error": "phonenumber is already confirmed"
			});
		}
		final chatter = Query<Chatter>(context)
			..values.phonenumber = body['phonenumber'] as String
			..values.phonenumberConfirmToken = confirmation
			..where((i) => i.id).equalTo(id);
		final updated = await chatter.updateOne();
		return Response.ok(updated);
	}
	@Operation.put('token')
	Future<Response> confirmPhonenumber(@Bind.path('token') String token) async {
		final Map<String, dynamic> body = await request!.body.decode();
		final JwtClaim claim = verifyJwtHS256Signature(token, config.secret!);
		final id = claim['id'];
		final chatter = Query<Chatter>(context)
			..where((i) => i.id).equalTo(id);
		final chaschat = await chatter.fetchOne();
		if (chaschat?.phonenumberConfirmToken != body['confirmation']) {
			return Response.badRequest(body: {
				"error": "invalid confirmation token"
			});
		}
		final toUpdate = Query<Chatter>(context)
			..values.isConfirmedPhonenumber = true
			..where((i) => i.id).equalTo(id);
		final updated = await toUpdate.updateOne();
		return Response.ok("");
	}
}
