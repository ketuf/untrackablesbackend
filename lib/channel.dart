import 'package:backend/backend.dart';
import 'package:backend/controllers/register_controller.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:backend/models/config.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/controllers/chatter_controller.dart';
import 'package:backend/controllers/following_controller.dart';
import 'package:backend/controllers/chat_controller.dart';
import 'package:backend/controllers/profile_controller.dart';
import 'package:backend/controllers/profile_following_controller.dart';
import 'package:backend/controllers/profile_followers_controller.dart';
import 'package:backend/controllers/conversations_controller.dart';
import 'package:backend/controllers/stream_controller.dart';
import 'package:backend/controllers/likes_controller.dart';
import 'package:backend/controllers/login_controller.dart';
import 'package:backend/controllers/block_controller.dart';
import 'package:backend/models/comment.dart';
import 'package:backend/controllers/comments_controller.dart';
/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class BackendChannel extends ApplicationChannel {
	ManagedContext? context;
	SmtpServer? smtp;
	Config? config;
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
	'coschol', 'paschass', 'localhost', 5432, 'untrack'
    );
    context = ManagedContext(dataModel, presistanceStore);
    config = Config(options!.configurationFilePath!);
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
	router.route('/example').linkFunction((request) async {
		return Response.ok({"key": "value"});
	});
	    router.route('/register/[:token]')
	    .link(() => RegisterController(context!, config!));

	router.route('/chatter').link(() => ChatterController(context!, config!.authSecret!));

	router.route('/following/[:id]').link(() => FollowingController(context!, config!.authSecret!));

	router.route('/chat/[:to]').link(() => ChatController(context!, config!.authSecret!));

	router.route('/profile/[:jwt]').link(() => ProfileController(context!, config!.authSecret!));

	router.route('/profile_following/[:jwt]').link(() => ProfileFollowingController(context!, config!.authSecret!));

	router.route('/profile_followers/[:jwt]').link(() => ProfileFollowersController(context!, config!.authSecret!));

	router.route('/conversations').link(() => ConversationsController(context!, config!.authSecret!));

	router.route('/stream').link(() => StreamController(context!, config!.authSecret!));

	router.route('/likes/[:id]').link(() => LikesController(context!, config!.authSecret!));

	router.route('/login').link(() => LoginController(context!, config!.authSecret!));
	router.route('/block/[:jwt]').link(() => BlockController(context!, config!.authSecret!));
	router.route('/comments/[:id]').link(() => CommentsController(context!, config!.authSecret!));
    return router;
  }
}
