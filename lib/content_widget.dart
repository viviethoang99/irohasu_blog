import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:irohasu_blog/shared/spacing.dart';

import 'cubit/posts/posts_cubit.dart';
import 'post.dart';
import 'router.dart';
import 'shared/decoration.dart';
import 'shared/text.dart';

class ContentHomeWidget extends StatelessWidget {
  const ContentHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<PostsCubit, PostsState>(
            builder: (_, state) {
              return state.when(
                initial: () => ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return const _PostWidget();
                  },
                ),
                loaded: (posts) => ListView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final post = Post.fromJson(
                      jsonDecode(posts[index].description ?? ''),
                    );
                    return _PostWidget(
                      post: post,
                      endpoint: posts[index].id,
                    );
                  },
                ),
                failed: (err) => const SizedBox.shrink(),
              );
            },
          ),
          const _PaginatorWidget(),
          const VSpace(26),
        ],
      ),
    );
  }
}

class _PostWidget extends StatelessWidget {
  const _PostWidget({
    this.post,
    this.endpoint,
  });

  final Post? post;
  final String? endpoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      decoration: IrohaDecoration.decoration(
        Theme.of(context).cardColor,
        Theme.of(context).colorScheme.shadow.withOpacity(0.15),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: () {
                return context.goNamed(
                  AppRouter.posts,
                  pathParameters: {
                    'endpoint': endpoint!,
                  },
                );
              },
              child: AspectRatio(
                aspectRatio: 3,
                child: post == null
                    ? const SizedBox.shrink()
                    : Image.network(
                        post!.image!,
                        fit: BoxFit.fitWidth,
                        width: double.infinity,
                      ),
              ),
            ),
          ),
          _ContentWidget(post: post),
        ],
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({
    this.post,
  });

  final Post? post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IrohaText.semibold(
            post?.name ?? '',
            fontSize: 25,
            maxLines: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: IrohaText.regular(
              post?.content ?? '',
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const IrohaText.regular(
                'Đọc tiếp',
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginatorWidget extends StatelessWidget {
  const _PaginatorWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 60,
          padding: const EdgeInsets.all(10),
          decoration: IrohaDecoration.decoration(
            Theme.of(context).cardColor,
            Theme.of(context).colorScheme.shadow.withOpacity(0.1),
          ),
          child: const Center(child: IrohaText.regular('Trước')),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          width: 60,
          decoration: IrohaDecoration.decoration(
            Theme.of(context).cardColor,
            Theme.of(context).colorScheme.shadow.withOpacity(0.1),
          ),
          child: const Center(
            child: IrohaText.regular('Sau'),
          ),
        ),
      ],
    );
  }
}
