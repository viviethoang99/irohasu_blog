import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irohasu_blog/cubit/posts/posts_cubit.dart';
import 'package:irohasu_blog/home/presentation/post_widget.dart';
import 'package:irohasu_blog/shared/iroha_scaffold.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';
import 'package:irohasu_blog/shared/spacing.dart';
import 'package:irohasu_blog/shared/text.dart';

import 'home/presentation/profile_widget.dart';
import 'post_api_service/post_api_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return IrohaScaffold(
      child: BlocProvider<PostsCubit>(
        create: (context) => PostsCubit(
          RepositoryProvider.of<ApiService>(context),
        )..initLoad(),
        child: const ResponsiveWidget(
          largeScreen: _LargeWidget(),
          mediumScreen: _MediumScreen(),
          smallScreen: _MediumScreen(),
        ),
      ),
    );
  }
}

class _MediumScreen extends StatelessWidget {
  const _MediumScreen();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),
          child: const Column(
            children: [
              VSpace(40), 
              VSpace(30),
              ListPostWidget(),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    IrohaText.semibold(
                      'Power by Flutter',
                      fontSize: 15,
                    )
                  ],
                ),
              )
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
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HSpace(40),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: const ProfileWidget(),
                    ),
                  ),
                ),
                const HSpace(40),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: const ListPostWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                IrohaText.semibold(
                  'Power by Flutter',
                  fontSize: 15,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
