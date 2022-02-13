import 'package:backend/backend.dart';
import 'package:backend/models/following.dart';
import 'package:backend/models/message.dart';
import 'package:backend/models/like.dart';
import 'package:backend/models/comment.dart';
class Chatter extends ManagedObject<_Chatter> implements _Chatter {}
class _Chatter {
	@Column(primaryKey: true)
	String? id;
	@Column(unique: true)
	String? email;
	@Column()
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
	String? secret;
	ManagedSet<Following>? following;

	ManagedSet<Following>? followers;

	ManagedSet<Message>? fromMessages;
	ManagedSet<Message>? toMessages;
	ManagedSet<Like>? likes;
	ManagedSet<Comment>? comments;
}
