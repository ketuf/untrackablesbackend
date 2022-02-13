import 'package:backend/backend.dart';
import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/helpers/extract_token.dart';

class ChatterController extends ResourceController {
	final ManagedContext context;
	final String secret;
	ChatterController(this.context, this.secret);

	@Operation.get()
	Future<Response> getChatter() async {
		final ischid = extractToken(request!.raw.headers.value("x-api-key")!, secret);
		final query = Query<Chatter>(context)
			..where((i) => i.id).equalTo(ischid);
		final chatter = await query.fetchOne();
		return Response.ok({
			"id": chatter?.id
		});
	}
	@Operation.post('id')
	Future<Response> follow() async {
		return Response.ok("");
	}

}
