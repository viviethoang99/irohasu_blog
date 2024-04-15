import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:irohasu_blog/cubit/post_detail/post_detail_cubit.dart';
import 'package:irohasu_blog/plugins/editor_plugins/code_block/appflowy_code_block.dart';
import 'package:irohasu_blog/plugins/editor_plugins/code_block/code_block_component.dart';
import 'package:irohasu_blog/shared/reponsiveness.dart';

import 'appbar_widget.dart';

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
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailCubit>(
      create: (context) => PostDetailCubit(widget.id)..initLoading(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarWidget(),
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
                          data.files!.first.content!,
                        ),
                      );
                      return buildEditor(editotState);
                    },
                    failed: (err) => const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditor(EditorState editorState) {
    return AppFlowyEditor(
      editorState: editorState,
      editable: false,
      editorStyle: customizeEditorStyle(),
      blockComponentBuilders: customBuilder(editorState),
    );
  }

  /// custom the block style
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
      HeadingBlockKeys.type: HeadingBlockComponentBuilder(
        configuration: configuration,
      ),

      // todo-list block
      TodoListBlockKeys.type: TodoListBlockComponentBuilder(
        configuration: configuration,
        iconBuilder: (context, node) {
          final checked = node.attributes[TodoListBlockKeys.checked] as bool;
          return GestureDetector(
            onTap: () => editorState.apply(
              editorState.transaction
                ..updateNode(node, {TodoListBlockKeys.checked: !checked}),
            ),
            child: Icon(
              checked ? Icons.check_box : Icons.check_box_outline_blank,
              size: 20,
              color: Colors.white,
            ),
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
        padding: const EdgeInsets.all(20),
        editorState: editorState,
      ),
    };
  }

  /// custom the text style
  EditorStyle customizeEditorStyle() {
    return EditorStyle(
      padding: ResponsiveWidget.isSmallScreen(context)
          ? const EdgeInsets.symmetric(horizontal: 20)
          : const EdgeInsets.only(left: 200, right: 200),
      cursorColor: Colors.green,
      dragHandleColor: Colors.green,
      selectionColor: Colors.green.withOpacity(0.5),
      textStyleConfiguration: TextStyleConfiguration(
        text: TextStyle(
          fontSize: 16.0,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        bold: const TextStyle(fontWeight: FontWeight.w900),
        code: const TextStyle(fontSize: 16.0),
      ),
      textSpanDecorator: (context, node, index, text, before, _) {
        final attributes = text.attributes;

        final href = attributes?[AppFlowyRichTextKeys.href];
        if (href != null) {
          return TextSpan(
            text: text.text,
            style: before.style,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                debugPrint('onTap: $href');
              },
          );
        }

        final code = attributes?[AppFlowyRichTextKeys.code];
        if (code != null) {
          return WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                text.text,
                style: before.style,
              ),
            ),
          );
        }
        return before;
      },
    );
  }
}
