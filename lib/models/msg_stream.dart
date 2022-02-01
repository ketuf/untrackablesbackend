class MsgStream {
  bool isUs;
  bool isFromMutual;
  bool isToMutual;
  int msgId;
  String? from;
  String? fromEncryptedId;
  String? to;
  String? toEncryptedId;
  String value;
  DateTime date;
  MsgStream({
    required this.isUs,
    required this.isFromMutual,
    required this.isToMutual,
    required this.msgId,
    this.from,
    this.fromEncryptedId,
    this.to,
    this.toEncryptedId,
    required this.value,
    required this.date
  });
  Map<String, dynamic> toJson() => {
    'isUs': isUs,
    'isFromMutual': isFromMutual,
    'isToMutual': isToMutual,
    'msgId': msgId,
    'from': from,
    'fromEncryptedId': fromEncryptedId,
    'to': to,
    'value': value,
    'toEncryptedId': toEncryptedId,
    'date': date.toString()
  };
}
