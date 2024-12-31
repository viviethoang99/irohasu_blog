import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irh_editor/plugins/editor_plugins/code_block/code_block_actions.dart';
import 'package:irh_editor/plugins/editor_plugins/code_block/code_block_block_component.dart';
import 'package:irh_editor/plugins/editor_plugins/code_block/code_block_style.dart';
import 'package:irohasu_blog/config/extension/extension.dart';
import 'package:irohasu_blog/editor_style.dart';
import 'package:irohasu_blog/post.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';
import 'package:irohasu_blog/shared/text.dart';

import 'shared/spacing.dart';
import 'table_of_contents.dart';

class PostDetailLoaded extends StatefulWidget {
  const PostDetailLoaded({
    super.key,
    required this.post,
    required this.editorState,
    required this.count,
  });

  final Post post;
  final EditorState editorState;
  final int count;

  @override
  State<PostDetailLoaded> createState() => _PostDetailLoadedState();
}

class _PostDetailLoadedState extends State<PostDetailLoaded> {
  late final EditorScrollController _controller;
  late final EditorStyleCustomizer _styleCustomizer;

  Post get post => widget.post;

  @override
  void initState() {
    _controller = EditorScrollController(editorState: widget.editorState);
    _styleCustomizer = EditorStyleCustomizer(
      context: context,
      padding: EdgeInsets.zero,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 900,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              constraints: const BoxConstraints(maxWidth: 750),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IntrinsicHeight(
                child: AppFlowyEditor(
                  header: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VSpace(20),
                        if (post.title?.isNotEmpty ?? false) ...[
                          IrohaText.semibold(
                            post.title ?? '',
                            fontSize: 30,
                            textAlign: TextAlign.start,
                            maxLines: null,
                          ),
                          const VSpace(10),
                        ],
                        if (post.createdAt != null) ...[
                          IrohaText.regular(
                            subContent,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const VSpace(12),
                        ]
                      ],
                    ),
                  ),
                  footer: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(top: 20),
                  ),
                  editorState: widget.editorState,
                  editable: false,
                  shrinkWrap: true,
                  showMagnifier: false,
                  editorStyle: _styleCustomizer.style(),
                  disableScrollService: true,
                  editorScrollController: _controller,
                  blockComponentBuilders: customBuilder(),
                ),
              ),
            ),
          ),
          const HSpace(8),
          ResponsiveWidget.isLargeScreen(context)
              ? Align(
                  alignment: Alignment.topRight,
                  child: TableOfContents(
                    controller: _controller,
                    editorState: widget.editorState,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  String get subContent {
    final createAt = post.createdAt?.date2String();
    final tags = post.tags?.where((e) => e.isNotEmpty).join(', ') ?? '';

    return '$createAt - $tags - ${widget.count} từ';
  }

  Map<String, BlockComponentBuilder> customBuilder() {
    final configuration = BlockComponentConfiguration(
      padding: (node) {
        if (HeadingBlockKeys.type == node.type) {
          return const EdgeInsets.symmetric(vertical: 20);
        }
        return const EdgeInsets.symmetric(vertical: 5);
      },
      indentPadding: (node, textDirection) =>
          textDirection == TextDirection.ltr ? const EdgeInsets.only(left: 26.0) : const EdgeInsets.only(right: 26.0),
    );

    // customize heading block style
    return {
      ...standardBlockComponentBuilderMap,

      // heading block
      // HeadingBlockKeys.type: CustomHeadingBlockComponentBuilder(
      //   configuration: configuration,
      //   textStyleBuilder: (level) => _styleCustomizer.headingStyleBuilder(level),
      // ),

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
          foregroundColor: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white,
        ),
        padding: const EdgeInsets.all(20).copyWith(bottom: 10),
        actions: CodeBlockActions(
          onCopy: (code) => Clipboard.setData(ClipboardData(text: code)),
        ),
      ),
    };
  }
}
