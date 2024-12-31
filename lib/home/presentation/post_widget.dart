import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';

import '../../cubit/posts/posts_cubit.dart';
import '../../post.dart';
import '../../router.dart';
import '../../shared/child_divider.dart';
import '../../shared/decoration.dart';
import '../../shared/spacing.dart';
import '../../shared/text.dart';

class ListPostWidget extends StatelessWidget {
  const ListPostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ChildDivider(
            child: IrohaText.semibold(
              'Bài viết mới',
              fontSize: 25,
            ),
          ),
        ),
        const VSpace(8),
        ResponsiveWidget.isLargeScreen(context)
            ? const Expanded(
                child: _PostContentWidget(
                  physics: ClampingScrollPhysics(),
                ),
              )
            : const _PostContentWidget(
                physics: NeverScrollableScrollPhysics(),
              )
      ],
    );
  }
}

class _PostContentWidget extends StatelessWidget {
  const _PostContentWidget({
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (_, state) {
        return state.when(
          initial: () => ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: physics,
            itemBuilder: (_, index) {
              return const _PostWidget();
            },
          ),
          loaded: (posts) => ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: physics,
            itemBuilder: (context, index) {
              final post = posts[0];
              return _PostWidget(
                post: post,
                endpoint: posts[0].id,
                createAt: posts[0].createdAt,
              );
            },
          ),
          failed: (err) => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _PostWidget extends StatefulWidget {
  const _PostWidget({
    this.post,
    this.endpoint,
    this.createAt,
  });

  final Post? post;
  final String? endpoint;
  final DateTime? createAt;

  @override
  State<_PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<_PostWidget> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRouter.posts,
            pathParameters: {'endpoint': widget.post?.id ?? ''},
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: isHover
              ? IrohaDecoration.decoration(
                  Theme.of(context).cardColor,
                  Theme.of(context).colorScheme.shadow.withOpacity(0.15),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.post?.title?.isNotEmpty ?? false) ...[
                  IrohaText.semibold(
                    widget.post?.title ?? '',
                    fontSize: 20,
                  ),
                  const VSpace(10),
                ],
                if (widget.post?.description?.isNotEmpty ?? false) ...[
                  IrohaText.regular(
                    widget.post?.description ?? '',
                    maxLines: 5,
                    fontSize: 15,
                    overflow: TextOverflow.visible,
                    height: 23 / 15,
                  ),
                  const VSpace(10),
                ],
                if (widget.createAt != null)
                  IrohaText.regular(
                    DateFormat('yyyy-MM-dd').format(widget.createAt!),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
