class ProfileFollow {
	bool mutual;
	String nickname;
	String? encryptedId;
	ProfileFollow({
		required this.mutual,
		required this.nickname,
		this.encryptedId
	});
	Map<String, dynamic> toJson() => {
		'mutual': mutual,
		'nickname': nickname,
		'encryptedId': encryptedId
	};
}
