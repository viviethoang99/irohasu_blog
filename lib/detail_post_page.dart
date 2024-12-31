import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irohasu_blog/cubit/post_detail/post_detail_cubit.dart';
import 'package:irohasu_blog/post_detail_loaded.dart';
import 'package:irohasu_blog/shared/iroha_scaffold.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';

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
      child: IrohaScaffold(
        floatingActionButton: BlocBuilder<PostDetailCubit, PostDetailState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (post, _, __) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ResponsiveWidget.isLargeScreen(context)
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: FloatingActionButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.menu),
                            ),
                          ),
                    FloatingActionButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_upward),
                    ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
        child: ConstrainedBox(
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
