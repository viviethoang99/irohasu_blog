import 'dart:async';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:irohasu_blog/post.dart';

import '../../post_api_service/post_api_service.dart';

part 'post_detail_state.dart';
part 'post_detail_cubit.freezed.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  PostDetailCubit(this.id, this._apiService) : super(const PostDetailState.initial());

  final String id;
  final ApiService _apiService;

  FutureOr initLoading() async {
    final result = await _apiService.getContent(id);
    final post = result.data;

    final editorState = EditorState(
      document: markdownToDocument(post.content ?? 'Hello world'),
    );

    final countWord = WordCountService(editorState: editorState)..register();

    emit(
      PostDetailState.loaded(
        post: post,
        editorState: editorState,
        countWord: countWord.getDocumentCounters().wordCount,
      ),
    );
  }
}
