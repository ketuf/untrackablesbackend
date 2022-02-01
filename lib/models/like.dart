import 'package:conduit/conduit.dart';
import 'package:backend/models/chatter.dart';
import 'package:backend/models/message.dart';
class Like extends ManagedObject<_Like> implements _Like {}

class _Like {
    @primaryKey
    int? id;

    @Relate(#likes)
    Chatter? chatter;

    @Relate(#likes)
    Message? message;
    @Column()
    DateTime? date;
}
