class Msg {
	bool? ours;
	String value;
	DateTime date;	
	Msg({ this.ours, required this.value, required this.date });
	Map<String, dynamic> toJson() => {
		'ours': ours,
		'value': value,
		'date': date.toString()
	};
}
