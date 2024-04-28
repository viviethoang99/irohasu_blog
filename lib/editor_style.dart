import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:irohasu_blog/cubit/document_appearance/document_appearance_cubit.dart';

const builtInFontFamily = 'Poppins';

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
          color: theme.colorScheme.onBackground,
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
        code: GoogleFonts.robotoMono(
          textStyle: baseTextStyle(fontFamily).copyWith(
            fontSize: fontSize - 2,
            fontWeight: FontWeight.normal,
            color: Colors.red,
            backgroundColor: theme.colorScheme.inverseSurface.withOpacity(0.8),
          ),
        ),
      ),
      // textSpanDecorator: customizeAttributeDecorator,
    );
  }

  TextStyle baseTextStyle(
    String fontFamily, {
    FontWeight? fontWeight,
  }) {
    try {
      return GoogleFonts.getFont(
        fontFamily,
        fontWeight: fontWeight,
      );
    } on Exception {
      // if ([builtInFontFamily, builtInCodeFontFamily].contains(fontFamily)) {
      //   return TextStyle(
      //     fontFamily: fontFamily,
      //     fontWeight: fontWeight,
      //   );
      // }

      return GoogleFonts.getFont(builtInFontFamily);
    }
  }
}
