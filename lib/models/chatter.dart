import 'package:backend/backend.dart';
import 'package:conduit/managed_auth.dart';
import 'package:backend/models/following.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/like.dart';
class Chatter extends ManagedObject<_Chatter> implements _Chatter, ManagedAuthResourceOwner<_Chatter> {}

class _Chatter extends ResourceOwnerTableDefinition {
	@Serialize(input: true, output: false)
	String? password;
	@Column(unique: true)
	String? nickname;
	@Column(defaultValue: 'false')
	bool? isConfirmedEmail;
	@Column(nullable: true)
	String? phonenumber;
	@Column(unique: true, nullable: true)
	String? phonenumberConfirmToken;
	@Column(defaultValue: 'false')
	bool? isConfirmedPhonenumber;
	@Column()
	String? qrId;
	@Column()
	String? secret;
	ManagedSet<Following>? following;

	ManagedSet<Following>? followers;

	ManagedSet<Message>? fromMessages;
	ManagedSet<Message>? toMessages;
	ManagedSet<Like>? likes;
}
