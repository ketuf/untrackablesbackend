import 'package:backend/backend.dart';

class Config extends Configuration {
	Config(String fileName): super.fromFile(File(fileName));
	String? host;
	int? port;
	String? username;
	String? password;
	String? secret;
	String? authSecret;
}
