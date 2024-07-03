import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irohasu_blog/config/extension/extension.dart';
import 'package:irohasu_blog/cubit/post_detail/post_detail_cubit.dart';
import 'package:irohasu_blog/plugins/header_plugins.dart';
import 'package:irohasu_blog/post.dart';
import 'package:irohasu_blog/shared/iroha_scaffold.dart';
import 'package:irohasu_blog/shared/spacing.dart';

import 'editor_style.dart';
import 'plugins/editor_plugins/code_block/code_block_actions.dart';
import 'plugins/editor_plugins/code_block/code_block_block_component.dart';
import 'plugins/editor_plugins/code_block/code_block_style.dart';
import 'post_api_service/post_api_service.dart';
import 'shared/text.dart';

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
  late final EditorStyleCustomizer _styleCustomizer;

  @override
  void initState() {
    _styleCustomizer = EditorStyleCustomizer(
      context: context,
      padding: EdgeInsets.zero,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailCubit>(
      create: (context) => PostDetailCubit(
        widget.id,
        RepositoryProvider.of<ApiService>(context),
      )..initLoading(),
      child: IrohaScaffold(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const VSpace(20),
                  BlocBuilder<PostDetailCubit, PostDetailState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        loaded: (data) {
                          final editotState = EditorState(
                            document: markdownToDocument(
                              data.content ?? '',
                            ),
                          );
                          return buildEditor(editotState, data, data.createdAt);
                        },
                        failed: (err) => const SizedBox.shrink(),
                      );
                    },
                  ),
                  const VSpace(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget buildEditor(EditorState editorState, Post? post, DateTime? createAt) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      constraints: const BoxConstraints(
        maxWidth: 900,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post?.title?.isNotEmpty ?? false) ...[
            IrohaText.semibold(
              post?.title ?? '',
              fontSize: 30,
            ),
            const VSpace(10),
          ],
          if (createAt != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IrohaText.regular(
                createAt.date2String(),
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          AppFlowyEditor(
            editorState: editorState,
            editable: false,
            editorStyle: _styleCustomizer.style(),
            blockComponentBuilders: customBuilder(editorState),
          ),
        ],
      ),
    );
  }


  /// Returns a map of custom builders for different block components in the editor.
  ///
  /// The [editorState] parameter represents the current state of the editor.
  ///
  /// The returned map contains custom builders for various block components, such as headings, todo lists, bulleted lists, quotes, and code blocks.
  /// Each builder is associated with a specific block type and is responsible for customizing the appearance and behavior of that block component.
  ///
  /// The [configuration] parameter is an instance of [BlockComponentConfiguration] that provides configuration options for the block components.
  /// It specifies the padding and indent padding for each block component.
  ///
  /// The [textStyleBuilder] parameter is a function that takes a heading level as input and returns a text style for that heading level.
  ///
  /// The [iconBuilder] parameter is a function that takes a context, a node, and an index as input and returns an icon widget for the block component.
  ///
  /// The [CodeBlockKeys.type] block component is customized using the [CodeBlockComponentBuilder] class.
  /// It provides a custom configuration, style, padding, and actions for code blocks.
  ///
  /// Example usage:
  /// ```dart
  /// final customBuilders = customBuilder(editorState);
  /// ```
  Map<String, BlockComponentBuilder> customBuilder(
    EditorState editorState,
  ) {
    final configuration = BlockComponentConfiguration(
      padding: (node) {
        if (HeadingBlockKeys.type == node.type) {
          return const EdgeInsets.symmetric(vertical: 20);
        }
        return const EdgeInsets.symmetric(vertical: 5);
      },
      indentPadding: (node, textDirection) => textDirection == TextDirection.ltr
          ? const EdgeInsets.only(left: 26.0)
          : const EdgeInsets.only(right: 26.0),
    );

    // customize heading block style
    return {
      ...standardBlockComponentBuilderMap,

      // heading block
      HeadingBlockKeys.type: CustomHeadingBlockComponentBuilder(
        configuration: configuration,
        textStyleBuilder: (level) =>
            _styleCustomizer.headingStyleBuilder(level),
      ),

      // todo-list block
      TodoListBlockKeys.type: TodoListBlockComponentBuilder(
        configuration: configuration,
        iconBuilder: (context, node, __) {
          final checked = node.attributes[TodoListBlockKeys.checked] as bool;
          return Icon(
            checked ? Icons.check_box : Icons.check_box_outline_blank,
            size: 20,
            color: Colors.white,
          );
        },
      ),
      // bulleted list block
      BulletedListBlockKeys.type: BulletedListBlockComponentBuilder(
        configuration: configuration,
        iconBuilder: (context, node) {
          return const Padding(
            padding: EdgeInsets.only(left: 10, right: 15, top: 5),
            child: Icon(
              Icons.circle,
              size: 10,
            ),
          );
        },
      ),
      // quote block
      QuoteBlockKeys.type: QuoteBlockComponentBuilder(
        configuration: configuration,
        iconBuilder: (context, node) {
          return const EditorSvg(
            width: 20,
            height: 20,
            padding: EdgeInsets.only(right: 5.0),
            name: 'quote',
            color: Colors.pink,
          );
        },
      ),

      CodeBlockKeys.type: CodeBlockComponentBuilder(
        configuration: BlockComponentConfiguration(
          textStyle: (_) => GoogleFonts.firaCode(
            fontSize: 14,
          ),
        ),
        styleBuilder: () => CodeBlockStyle(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          foregroundColor:
              Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
        ),
        padding: const EdgeInsets.all(20).copyWith(bottom: 10),
        actions: CodeBlockActions(
          onCopy: (code) => Clipboard.setData(ClipboardData(text: code)),
        ),
      ),
    };
  }
}
