import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irohasu_blog/cubit/post_detail/post_detail_cubit.dart';
import 'package:irohasu_blog/post_detail_loaded.dart';

import 'post_api_service/post_api_service.dart';

class DetailPostPage extends StatelessWidget {
  const DetailPostPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailCubit>(
      create: (context) => PostDetailCubit(
        id,
        RepositoryProvider.of<ApiService>(context),
      )..initLoading(),
      child: Scaffold(
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: BlocBuilder<PostDetailCubit, PostDetailState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  loaded: (post, editorState, count) {
                    return PostDetailLoaded(
                      post: post,
                      editorState: editorState,
                      count: count,
                    );
                  },
                  failed: (err) => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
