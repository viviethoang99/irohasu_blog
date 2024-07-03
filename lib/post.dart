import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

typedef Posts = List<Post>;

@JsonSerializable()
final class Post {
  const Post({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.description,
    this.content,
    this.urlImage,
    this.endpoint,
    this.tags,
  });

  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? title;
  final String? description;
  final String? content;
  final String? urlImage;
  final String? endpoint;
  final List<String>? tags;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@JsonSerializable()
final class Tag {
  const Tag({this.name, this.endpoint});

  final String? name;
  final String? endpoint;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
