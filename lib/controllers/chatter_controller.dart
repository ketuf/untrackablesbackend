import 'package:backend/backend.dart';
import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';


class ChatterController extends ResourceController {
	final ManagedContext context;
	ChatterController(this.context);

	@Operation.get()
	Future<Response> getChatter() async {
		print('asjfhjasfh');
		final query = Query<Chatter>(context)
			..where((i) => i.id).equalTo(request?.authorization?.ownerID);
		final chatter = await query.fetchOne();
		return Response.ok({
			"id": chatter?.qrId
		});
	}
	@Operation.post('id')
	Future<Response> follow() async {
		return Response.ok("");		
	}

}
