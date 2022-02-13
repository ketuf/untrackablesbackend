
class CommentDto {
  String value;
  DateTime date;
  String encryptedId;
  CommentDto({
    required this.value,
    required this.date,
    required this.encryptedId
  });
  Map<String, dynamic> toJson() => {
    'value': value,
    'date': date.toString(),
    'encryptedId': encryptedId
  };
}
