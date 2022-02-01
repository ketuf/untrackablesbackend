import 'package:conduit/conduit.dart';

class TestController extends ResourceController {
	ManagedDbContext context;
	TestController(this.context);

	@Operation.post()
	Future<Response>
	
}
