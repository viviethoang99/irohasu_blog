import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' as highlight;

import 'actions_service.dart';
import 'code_block_style.dart';
import 'default_dark_theme.dart';
import 'default_light_theme.dart';

class CodeBlockKeys {
  const CodeBlockKeys._();

  static const String type = 'code';

  /// The content of a code block.
  ///
  /// The value is a String.
  static const String delta = 'delta';

  /// The language of a code block.
  ///
  /// The value is a String.
  static const String language = 'language';
}

class CodeBlockComponentWidget extends BlockComponentStatefulWidget {
  const CodeBlockComponentWidget({
    super.key,
    required super.node,
    super.showActions,
    super.actionBuilder,
    super.configuration = const BlockComponentConfiguration(),
    this.padding = const EdgeInsets.all(0),
    required this.editorState,
  });

  final EdgeInsets padding;
  final EditorState editorState;

  @override
  State<CodeBlockComponentWidget> createState() =>
      _CodeBlockComponentWidgetState();
}

class _CodeBlockComponentWidgetState extends State<CodeBlockComponentWidget>
    with
        SelectableMixin,
        DefaultSelectableMixin,
        BlockComponentConfigurable,
        BlockComponentTextDirectionMixin {
  @override
  final forwardKey = GlobalKey(debugLabel: 'flowy_rich_text');

  @override
  GlobalKey<State<StatefulWidget>> blockComponentKey = GlobalKey(
    debugLabel: CodeBlockKeys.type,
  );

  @override
  BlockComponentConfiguration get configuration => widget.configuration;

  @override
  GlobalKey<State<StatefulWidget>> get containerKey => node.key;

  @override
  Node get node => widget.node;

  late final ActionsService actionsService;

  @override
  late final editorState = widget.editorState;

  String? get language => node.attributes[CodeBlockKeys.language] as String?;
  String? autoDetectLanguage;

  bool showActions = false;

  @override
  void initState() {
    super.initState();
    actionsService = ActionsService(editorState: editorState, node: node);
    setState(() {
      showActions = PlatformExtension.isMobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return BlockSelectionContainer(
      node: node,
      delegate: this,
      listenable: editorState.selectionNotifier,
      blockColor: editorState.editorStyle.selectionColor,
      supportTypes: const [
        BlockSelectionType.block,
      ],
      child: BlockComponentActionWrapper(
        node: widget.node,
        actionBuilder: widget.actionBuilder!,
        child: Padding(
          key: blockComponentKey,
          padding: padding,
          child: Container(
            decoration: BoxDecoration(
              color: isLightMode
                  ? CodeBlockStyle.lightBackground
                  : CodeBlockStyle.darkBackground,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // showActions
                //     ? ActionMenuWidget(
                //         actionsService: actionsService,
                //         editorState: editorState,
                //       )
                //     : const SizedBox(height: 34),
                _buildCodeBlock(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBlock(BuildContext context) {
    final delta = node.delta ?? Delta();
    final content = delta.toPlainText();
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    final result = highlight.highlight.parse(
      content,
      language: language,
      autoDetection: language == null,
    );
    autoDetectLanguage = language ?? result.language;

    final codeNodes = result.nodes;
    if (codeNodes == null) {
      throw Exception('Code block parse error.');
    }
    final codeTextSpans = _convert(codeNodes, isLightMode: isLightMode);
    return Padding(
      padding: widget.padding,
      child: AppFlowyRichText(
        key: forwardKey,
        delegate: this,
        node: widget.node,
        editorState: editorState,
        placeholderText: placeholderText,
        lineHeight: 1.5,
        textSpanDecorator: (textSpan) => TextSpan(
          style: textStyle.copyWith(
            color: isLightMode
                ? CodeBlockStyle.darkForeground
                : CodeBlockStyle.lightForeground,
          ),
          children: codeTextSpans,
        ),
        placeholderTextSpanDecorator: (textSpan) => TextSpan(
          style: textStyle,
        ),
      ),
    );
  }

  // Copy from flutter.highlight package.
  // https://github.com/git-touch/highlight.dart/blob/master/flutter_highlight/lib/flutter_highlight.dart
  List<TextSpan> _convert(
    List<highlight.Node> nodes, {
    bool isLightMode = true,
  }) {
    final List<TextSpan> spans = [];
    var currentSpans = spans;
    final List<List<TextSpan>> stack = [];

    final codeblockTheme = isLightMode ? defaultLightTheme : defaultDarkTheme;

    void traverse(highlight.Node node) {
      if (node.value != null) {
        currentSpans.add(
          node.className == null
              ? TextSpan(text: node.value)
              : TextSpan(
                  text: node.value,
                  style: codeblockTheme[node.className!],
                ),
        );
      } else if (node.children != null) {
        final List<TextSpan> tmp = [];
        currentSpans.add(
          TextSpan(
            children: tmp,
            style: codeblockTheme[node.className!],
          ),
        );
        stack.add(currentSpans);
        currentSpans = tmp;

        for (final n in node.children!) {
          traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
      }
    }

    for (final node in nodes) {
      traverse(node);
    }

    return spans;
  }
}
