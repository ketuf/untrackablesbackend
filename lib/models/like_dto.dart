
class LikeDto {
  bool isMutual;
  String? encryptedId;
  String nickname;
  DateTime date;
  LikeDto({
    required this.isMutual,
    this.encryptedId,
    required this.nickname,
    required this.date
  });
  Map<String, dynamic> toJson() => {
    'isMutual': isMutual,
    'encryptedId': encryptedId,
    'nickname': nickname,
    'date': date
  };



}
