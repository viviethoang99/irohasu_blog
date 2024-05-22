import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irohasu_blog/config/extension/string_extension.dart';
import 'package:irohasu_blog/cubit/document_appearance/document_appearance_cubit.dart';
import 'package:url_launcher/url_launcher_string.dart';

const builtInFontFamily = 'BeVietnamPro';

class EditorStyleCustomizer {
  EditorStyleCustomizer({
    required this.context,
    required this.padding,
  });

  final BuildContext context;
  final EdgeInsets padding;

  EditorStyle style() {
    return desktop();
    // if (PlatformExtension.isDesktopOrWeb) {
    //   return desktop();
    // } else if (PlatformExtension.isMobile) {
    //   return mobile();
    // }
    // throw UnimplementedError();
  }

  EditorStyle desktop() {
    final theme = Theme.of(context);
    final appearance = context.read<DocumentAppearanceCubit>().state;
    final fontSize = appearance.fontSize;
    final fontFamily = appearance.fontFamily;

    return EditorStyle.desktop(
      padding: padding,
      textStyleConfiguration: TextStyleConfiguration(
        text: baseTextStyle(fontFamily).copyWith(
          fontSize: fontSize,
          color: Theme.of(context).textTheme.bodyMedium?.color,
          height: 1.5,
        ),
        bold: baseTextStyle(fontFamily, fontWeight: FontWeight.bold).copyWith(
          fontWeight: FontWeight.w600,
        ),
        italic: baseTextStyle(fontFamily).copyWith(
          fontStyle: FontStyle.italic,
        ),
        underline: baseTextStyle(fontFamily).copyWith(
          decoration: TextDecoration.underline,
        ),
        strikethrough: baseTextStyle(fontFamily).copyWith(
          decoration: TextDecoration.lineThrough,
        ),
        href: baseTextStyle(fontFamily).copyWith(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
        code: baseTextStyle(fontFamily).copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.normal,
          color: Colors.red,
          backgroundColor: theme.colorScheme.inverseSurface.withOpacity(0.8),
        ),
      ),
      textSpanDecorator: customizeAttributeDecorator,
    );
  }

  TextStyle baseTextStyle(
    String fontFamily, {
    FontWeight? fontWeight,
  }) {
    try {
      final font = GoogleFonts.getFont(
        fontFamily,
        fontWeight: fontWeight,
      );
      return font;
    } catch (c) {
      if ([builtInFontFamily].contains(fontFamily)) {
        return TextStyle(
          fontFamily: fontFamily,
          fontWeight: fontWeight,
        );
      }

      return GoogleFonts.getFont(builtInFontFamily);
    }
  }

  InlineSpan customizeAttributeDecorator(
    BuildContext context,
    Node node,
    int index,
    TextInsert text,
    TextSpan before,
    TextSpan after,
  ) {
    final attributes = text.attributes;
    if (attributes == null) {
      return before;
    }

    // try to refresh font here.
    if (attributes.fontFamily != null) {
      try {
        if (before.text?.contains('_regular') == true) {
          GoogleFonts.getFont(attributes.fontFamily!.parseFontFamilyName());
        } else {
          return TextSpan(
            text: before.text,
            style: after.style?.merge(
              GoogleFonts.getFont(attributes.fontFamily!),
            ),
          );
        }
      } catch (e) {
        // ignore
      }
    }

    // Inline Mentions (Page Reference, Date, Reminder, etc.)
    final href = attributes[AppFlowyRichTextKeys.href];
    if (href != null) {
      return TextSpan(
        text: text.text,
        style: before.style,
        recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(href),
      );
    }

    final code = attributes[AppFlowyRichTextKeys.code];
    if (code != null) {
      return WidgetSpan(
        alignment: PlaceholderAlignment.baseline,
        baseline: TextBaseline.alphabetic,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
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

    return defaultTextSpanDecoratorForAttribute(
      context,
      node,
      index,
      text,
      before,
      after,
    );
  }

  TextStyle headingStyleBuilder(int level) {
    final fontSize = context.read<DocumentAppearanceCubit>().state.fontSize;
    final fontSizes = [
      fontSize + 16,
      fontSize + 12,
      fontSize + 8,
      fontSize + 4,
      fontSize + 2,
      fontSize,
    ];
    final fontFamily = context.read<DocumentAppearanceCubit>().state.fontFamily;
    return baseTextStyle(fontFamily, fontWeight: FontWeight.bold).copyWith(
      fontWeight: FontWeight.w600,
      fontSize: fontSizes.elementAtOrNull(level - 1) ?? fontSize,
    );
  }
}
