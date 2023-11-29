class Puser {
  String? uid;
  String? nickname;
  String? thumnail;
  String? description;
  Puser({
    this.uid,
    this.nickname,
    this.thumnail,
    this.description,
  });

  factory Puser.fromJson(Map<String, dynamic> json) {
    return Puser(
      uid: json['uid'] == null ? '' : json['uid'] as String,
      nickname: json['nickname'] == null ? '' : json['nickname'] as String,
      thumnail: json['thumnail'] == null ? '' : json['thumnail'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'thumnail': thumnail,
      'description': description,
    };
  }

  Puser copyWith({
    String? uid,
    String? nickname,
    String? thumnail,
    String? description,
  }) {
    return Puser(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      thumnail: thumnail ?? this.thumnail,
      description: description ?? this.description,
    );
  }
}
