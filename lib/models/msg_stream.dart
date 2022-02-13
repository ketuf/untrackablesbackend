class MsgStream {
  bool isFromMe;
  bool isToMe;
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
    required this.isFromMe,
    required this.isToMe,
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
    'isToMe': isToMe,
    'isFromMe': isFromMe,
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
