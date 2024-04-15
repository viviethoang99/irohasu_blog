import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irohasu_blog/cubit/posts/posts_cubit.dart';
import 'package:irohasu_blog/shared/profile_widget.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';
import 'package:irohasu_blog/shared/spacing.dart';

import 'appbar_widget.dart';
import 'content_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsCubit>(
      create: (context) => PostsCubit()..initLoad(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              AppBarWidget(),
              Padding(
                padding: EdgeInsets.all(20),
                child: ResponsiveWidget(
                  largeScreen: _LargeWidget(),
                  smallScreen: ContentHomeWidget(),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class _LargeWidget extends StatelessWidget {
  const _LargeWidget();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileWidget(),
        HSpace(20),
        Expanded(child: ContentHomeWidget())
      ],
    );
  }
}
