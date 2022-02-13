import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/message.dart';
class Comment extends ManagedObject<_Comment> implements _Comment {}
class _Comment {
  @primaryKey
  int? id;
  @Relate(#comments)
  Chatter? chatter;
  @Relate(#comments)
  Message? message;
  @Column()
  DateTime?date;
  @Column()
  String? value;
}
