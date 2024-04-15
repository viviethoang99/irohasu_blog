import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:irohasu_blog/post_detail.dart';

import '../../post_api_service/post_api_service.dart';

part 'post_detail_state.dart';
part 'post_detail_cubit.freezed.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  PostDetailCubit(this.id) : super(const PostDetailState.initial());

  final _repo = GistClient(Dio());

  final String id;

  FutureOr initLoading() async {
    final result = await _repo.getContent(id);
    emit(PostDetailState.loaded(result));
  }
}
