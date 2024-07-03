part of 'post_detail_cubit.dart';

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState.initial() = _Initial;
  const factory PostDetailState.loaded(Post posts) = _Loaded;
  const factory PostDetailState.failed(String error) = Error;
}
