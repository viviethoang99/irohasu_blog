part of 'posts_cubit.dart';

@freezed
class PostsState with _$PostsState {
  const factory PostsState.initial() = _Initial;
  const factory PostsState.loaded(List<Gist> posts) = _Loaded;
  const factory PostsState.failed(String error) = Error;
}
