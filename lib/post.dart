import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

typedef Posts = List<Post>;

@JsonSerializable()
class Post extends Equatable {
  const Post({
    required this.name,
    required this.image,
    required this.createAt,
    required this.content,
    required this.tag,
    required this.url,
  });

  final String? name;
  final String? image;
  final DateTime? createAt;
  final String? content;
  final String? tag;
  final String? url;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  @override
  List<Object?> get props => [name, image, createAt, content, tag, url];
}
