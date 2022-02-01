class Msg {
	bool? ours;
	bool? isMutual;
	String? toFrom;
	String? encryptedId;
	String? personalNickname;
	String value;
	DateTime date;
	Msg({ this.ours, this.isMutual, this.toFrom, this.encryptedId, this.personalNickname, required this.value, required this.date });
	Map<String, dynamic> toJson() => {
		'ours': ours,
		'encryptedId': encryptedId,
		'isMutual': isMutual,
		'toFrom': toFrom,
		'value': value,
		'date': date.toString()
	};
}
