class Follower {
	String nickname;
	String encryptedId;
	String? personalNickname;
	int following;
	int followers;
	Follower({ required this.nickname, this.personalNickname, required this.encryptedId, required this.following, required this.followers });
	Map<String, dynamic> toJson() => {
		'nickname': nickname,
		'encryptedId': encryptedId,
		'personalNickname': personalNickname,
		'following': following,
		'followers': followers
	};
}
