import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/like.dart';
import 'package:backend/models/comment.dart';
class Message extends ManagedObject<_Message> implements _Message {}

class _Message {
	@primaryKey
	int? id;
	@Column()
	String? value;
	@Column(defaultValue: 'false')
	bool? isPrivate;
	@Column()
	DateTime? date;
	@Relate(#fromMessages, isRequired: false, onDelete: DeleteRule.cascade)
	Chatter? from;
	@Relate(#toMessages, isRequired: false, onDelete: DeleteRule.cascade)
	Chatter? to;

	ManagedSet<Like>? likes;
	ManagedSet<Comment>? comments;
}
