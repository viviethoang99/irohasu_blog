import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:irohasu_blog/post.dart';

import '../../post_api_service/post_api_service.dart';

part 'posts_state.dart';
part 'posts_cubit.freezed.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this._apiService) : super(const PostsState.initial());

  final ApiService _apiService;

  Future<void> initLoad() async {
    getGist();
  }

  Future<void> getGist() async {
    final listData = await _apiService.getGist();
    emit(PostsState.loaded(listData.data ?? <Post>[]));
  }
}
