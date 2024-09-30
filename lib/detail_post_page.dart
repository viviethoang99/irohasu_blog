import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irh_editor/irh_editor.dart';
import 'package:irohasu_blog/cubit/post_detail/post_detail_cubit.dart';
import 'package:irohasu_blog/shared/iroha_scaffold.dart';
import 'package:irohasu_blog/shared/spacing.dart';

import 'editor_style.dart';
import 'post_api_service/post_api_service.dart';

class DetailPostPage extends StatefulWidget {
  const DetailPostPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IrohaScaffold(
      child: BlocProvider<PostDetailCubit>(
        create: (context) => PostDetailCubit(
          widget.id,
          RepositoryProvider.of<ApiService>(context),
        )..initLoading(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const VSpace(20),
                Expanded(
                  child: BlocBuilder<PostDetailCubit, PostDetailState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        loaded: (data) {
                          return _ContentWidget(
                            content: data.content ?? '',
                          );
                        },
                        failed: (err) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
                const VSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContentWidget extends StatefulWidget {
  const _ContentWidget({
    this.content = '',
    super.key,
  });

  final String content;

  @override
  State<_ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<_ContentWidget> {
  late final EditorStyleCustomizer _styleCustomizer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 800,
      ),
      child: MarkdownEditor(
        content: widget.content,
        editable: false,
      ),
    );
  }
}
