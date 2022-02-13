
class LikeDto {
  bool isOurs;
  bool isMutual;
  String? encryptedId;
  String nickname;
  DateTime date;
  LikeDto({
    required this.isOurs,
    required this.isMutual,
    this.encryptedId,
    required this.nickname,
    required this.date
  });
  Map<String, dynamic> toJson() => {
    'isOurs': isOurs,
    'isMutual': isMutual,
    'encryptedId': encryptedId,
    'nickname': nickname,
    'date': date.toString()
  };



}
