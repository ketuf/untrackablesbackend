import 'package:backend/backend.dart';
import 'package:backend/controllers/register_controller.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:backend/models/config.dart';
import 'package:backend/models/chatter.dart';
import 'package:conduit/managed_auth.dart';
import 'package:backend/controllers/chatter_controller.dart';
import 'package:backend/controllers/following_controller.dart';
import 'package:backend/controllers/chat_controller.dart';
import 'package:backend/controllers/profile_controller.dart';
import 'package:backend/controllers/profile_following_controller.dart';
import 'package:backend/controllers/profile_followers_controller.dart';
import 'package:backend/controllers/conversations_controller.dart';
import 'package:backend/controllers/stream_controller.dart';
import 'package:backend/controllers/likes_controller.dart';
/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class BackendChannel extends ApplicationChannel {
	ManagedContext? context;
	SmtpServer? smtp;
	Config? config;
	AuthServer? authServer;
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final presistanceStore = PostgreSQLPersistentStore.fromConnectionInfo(
    	'noah', 'noschoaschah', '127.0.0.1', 5432, 'uschun'
    );
    context = ManagedContext(dataModel, presistanceStore);
    config = Config(options!.configurationFilePath!);
    final authStorage = ManagedAuthDelegate<Chatter>(context);
    authServer = AuthServer(authStorage);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://conduit.io/docs/http/request_controller/
    router.route('/auth/token')
    .link(() => AuthController(authServer!));

    router.route("/example")
    .linkFunction((request) async {
      return Response.ok({"key": "value"});
    });
    router.route('/register/[:token]')
    .link(() => RegisterController(context!, config!, authServer!));

	router.route('/chatter')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => ChatterController(context!));

	router.route('/following/[:id]')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => FollowingController(context!));

	router.route('/chat/[:to]')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => ChatController(context!));

	router.route('/profile/[:jwt]')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => ProfileController(context!));

	router.route('/profile_following/[:jwt]')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => ProfileFollowingController(context!));

	router.route('/profile_followers/[:jwt]')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => ProfileFollowersController(context!));

	router.route('/conversations')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => ConversationsController(context!));

	router.route('/stream')
	.link(() => Authorizer.bearer(authServer!))
	?.link(() => StreamController(context!));

	router.route('/likes/[:id]')
		.link(() => Authorizer.bearer(authServer!))
		?.link(() => LikesController(context!));


    return router;
  }
}
