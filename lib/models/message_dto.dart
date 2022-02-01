class MessageDto {
	bool ours;
	String value;
	String encryptedId;
	String toFrom;
	DateTime date;
	MessageDto({ required this.ours, required this.value, required this.encryptedId, required this.toFrom, required this.date, });
	Map<String, dynamic> toJson() => {
		'encryptedId': encryptedId,
		'toFrom': toFrom,
		'ours': ours,
		'value': value,
		'date': date.toString()
	};
}
