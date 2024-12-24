part of 'post_detail_cubit.dart';

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState.initial() = _Initial;
  const factory PostDetailState.loaded({
    required Post post,
    required EditorState editorState,
    @Default(0) int countWord,
  }) = _Loaded;
  const factory PostDetailState.failed(String error) = Error;
}
