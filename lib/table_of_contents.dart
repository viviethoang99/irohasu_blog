import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:irohasu_blog/shared/text.dart';

import 'shared/spacing.dart';

class TableOfContents extends StatelessWidget {
  const TableOfContents({
    super.key,
    required this.controller,
    required this.editorState,
  });

  final EditorScrollController controller;
  final EditorState editorState;

  @override
  Widget build(BuildContext context) {
    return _buildOutlineBlock(context);
  }

  Widget _buildOutlineBlock(BuildContext context) {
    final (status, headings) = getHeadingNodes();

    Widget child;

    switch (status) {
      case _OutlineBlockStatus.noHeadings:
        child = const Align(
          alignment: Alignment.centerLeft,
          child: IrohaText.semibold(
            'Không có tiêu đề',
            fontSize: 16,
          ),
        );
      case _OutlineBlockStatus.noMatchHeadings:
        child = const Align(
          alignment: Alignment.centerLeft,
          child: IrohaText.semibold(
            'Không có tiêu đề phù hợp',
            fontSize: 16,
            // style: configuration.placeholderTextStyle(node),
          ),
        );
      case _OutlineBlockStatus.success:
        final children = headings
            .map(
              (e) => Container(
                padding: const EdgeInsets.only(
                  bottom: 4.0,
                ),
                width: double.infinity,
                child: OutlineItemWidget(
                  node: e,
                ),
              ),
            )
            .toList();
        child = Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Column(children: children),
        );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 250,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2.0,
          horizontal: 5.0,
        ),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != _OutlineBlockStatus.success) ...[
              IrohaText.semibold(
                'Thư mục bài viết',
                fontSize: 18,
              ),
              const VSpace(8.0),
            ],
            child,
          ],
        ),
      ),
    );
  }

  int get maxVisibleDepth => 3;

  (_OutlineBlockStatus, Iterable<Node>) getHeadingNodes() {
    final nodes = NodeIterator(
      document: editorState.document,
      startNode: editorState.document.root,
    ).toList();
    final level = maxVisibleDepth;

    var headings = nodes.where(
      (e) => _isHeadingNode(e),
    );

    if (headings.isEmpty) {
      return (_OutlineBlockStatus.noHeadings, []);
    }

    headings = headings.where(
      (e) => (e.type == HeadingBlockKeys.type && e.attributes[HeadingBlockKeys.level] <= level),
    );

    if (headings.isEmpty) {
      return (_OutlineBlockStatus.noMatchHeadings, []);
    }

    return (_OutlineBlockStatus.success, headings);
  }

  bool _isHeadingNode(Node node) {
    if (node.type == HeadingBlockKeys.type && node.delta?.isNotEmpty == true) {
      return true;
    }

    return false;
  }
}

enum _OutlineBlockStatus {
  noHeadings,
  noMatchHeadings,
  success;
}

class OutlineItemWidget extends StatelessWidget {
  const OutlineItemWidget({
    super.key,
    required this.node,
  });

  final Node node;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HSpace(node.leftIndent),
        Expanded(
          child: InkWell(
            onTap: () {
              // controller.scrollToNode(node);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IrohaText(
                node.outlineItemText,
                fontSize: 15,
                maxLines: null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final _availableBlockTypes = [
  HeadingBlockKeys.type,
];

extension on Node {
  double get leftIndent {
    assert(_availableBlockTypes.contains(type));

    if (!_availableBlockTypes.contains(type)) {
      return 0.0;
    }

    final level = attributes[HeadingBlockKeys.level];
    if (level != null) {
      final indent = (level - 1) * 4.0;
      return indent;
    }

    return 0.0;
  }

  String get outlineItemText {
    return delta?.toPlainText() ?? '';
  }
}
