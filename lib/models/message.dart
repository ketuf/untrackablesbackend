import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
class Message extends ManagedObject<_Message> implements _Message {}

class _Message {
	@primaryKey
	int? id;
	@Column() 
	String? value;		
	@Column()
	DateTime? date;
	@Relate(#fromMessages)
	Chatter? from;
	@Relate(#toMessages)
	Chatter? to;
	
}
