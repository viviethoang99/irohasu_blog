import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:irohasu_blog/post_api_service/gist.dart';

import '../../post_api_service/post_api_service.dart';

part 'posts_state.dart';
part 'posts_cubit.freezed.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(const PostsState.initial());

  final _repo = GistClient(Dio());

  Future<void> initLoad() async {
    // final response = await rootBundle.loadString('assets/demo/home.json');
    // final List jsonData = json.decode(response);
    // final listData = List<Post>.from(
    //   jsonData.map<Post>((e) => Post.fromJson(e)).toList(),
    // );
    // emit(PostsState.loaded(listData));

    getGist();
  }

  Future<void> getGist() async {
    final listData = await _repo.getGist();
    emit(PostsState.loaded(listData));
  }
}
