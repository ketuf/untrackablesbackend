import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
 class Following extends ManagedObject<_Following> implements _Following {}

 class _Following {
 	@primaryKey
 	int? id;
 	@Column()
 	String? nickname;
 	@Relate(#following)
 	Chatter? chatter;
 	@Relate(#followers)
 	Chatter? follower;
 }
