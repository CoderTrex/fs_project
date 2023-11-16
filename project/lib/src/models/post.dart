import 'package:project/src/models/project_user_.dart';

class Post {
  final String? id; // Post Id
  final String? thumbnail; // Post's thumbnail image
  final String? description; // post description
  final int? likecount; // like count
  final Puser? userInfo; // user's info
  final String? uid; // user ID
  final DateTime? createdAt; // the time the post was created
  final DateTime? deletedAt; // the time the post was deleted
  final DateTime? updatedAt; // the time the post was updeated

  Post({
    this.id,
    this.thumbnail,
    this.description,
    this.likecount,
    this.userInfo,
    this.uid,
    this.createdAt,
    this.deletedAt,
    this.updatedAt,
  });

  factory Post.init(Puser userInfo) {
    var time = DateTime.now();
    return Post(
      thumbnail: '',
      userInfo: userInfo,
      uid: userInfo.uid,
      description: '',
      createdAt: time,
      updatedAt: time,
    );
  }

  factory Post.fromJson(String docId, Map<String, dynamic> json) {
    return Post(
      id: json['id'] == null ? '' : json['id'] as String,
      thumbnail: json['thumbnail'] == null ? '' : json['thumbnail'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
      likecount: json['like_count'] == null ? 0 : json['like_count'] as int,
      userInfo:
          json['user_info'] == null ? null : Puser.fromJson(json['user_info']),
      uid: json['uid'] == null ? '' : json['uid'] as String,
      createdAt: json['created_at'] == null
          ? DateTime.now()
          : json['created_at'].toDate(),
      deletedAt: json['deleted_at'] == null
          ? DateTime.now()
          : json['deleted_at'].toDate(),
      updatedAt:
          json['updated_at'] == null ? null : json['updated_at'].toDate(),
    );
  }

  Post copyWith({
    String? id,
    String? thumbnail,
    String? description,
    int? likecount,
    Puser? userInfo,
    String? uid,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      likecount: likecount ?? this.likecount,
      userInfo: userInfo ?? this.userInfo,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'description': description,
      'like_count': likecount,
      'user_info': userInfo!.toMap(),
      'uid': uid,
      'created_at': createdAt,
      'deleted_at': deletedAt,
      'updated_at': updatedAt,
    };
  }
}
