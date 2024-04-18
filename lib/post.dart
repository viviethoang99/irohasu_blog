import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

typedef Posts = List<Post>;

@JsonSerializable()
class Post {
  const Post({
    required this.title,
    required this.content,
    required this.tag,
    required this.urlImage,
  });

  final String? title;
  final String? content;
  final String? tag;
  final String? urlImage;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
