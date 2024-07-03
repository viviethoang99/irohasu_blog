import 'package:freezed_annotation/freezed_annotation.dart';

import '../post.dart';

part 'list_posts.g.dart';

@JsonSerializable()
class ListPosts {
  final List<Post>? data;
  final Paging? paging;
  final Filter? filter;

  const ListPosts({
    this.data,
    this.paging,
    this.filter,
  });

  factory ListPosts.fromJson(Map<String, dynamic> json) =>
      _$ListPostsFromJson(json);
}

@JsonSerializable()
class Filter {
  final int? ownerId;

  const Filter({
    this.ownerId,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => _$FilterFromJson(json);
}

@JsonSerializable()
class Paging {
  final int? page;
  final int? limit;
  final int? total;
  final String? cursor;
  final String? nextCursor;

  const Paging({
    this.page,
    this.limit,
    this.total,
    this.cursor,
    this.nextCursor,
  });

  factory Paging.fromJson(Map<String, dynamic> json) => _$PagingFromJson(json);
}
