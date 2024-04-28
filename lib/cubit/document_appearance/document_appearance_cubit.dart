import 'package:bloc/bloc.dart';

class DocumentAppearanceCubit extends Cubit<DocumentAppearance> {
  DocumentAppearanceCubit()
      : super(
          const DocumentAppearance(
            fontSize: 14,
            fontFamily: 'Robocon',
            codeFontFamily: '123456',
          ),
        );
}

class DocumentAppearance {
  const DocumentAppearance({
    required this.fontSize,
    required this.fontFamily,
    required this.codeFontFamily,
  });

  final double fontSize;
  final String fontFamily;
  final String codeFontFamily;

  DocumentAppearance copyWith({
    double? fontSize,
    String? fontFamily,
    String? codeFontFamily,
  }) {
    return DocumentAppearance(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      codeFontFamily: codeFontFamily ?? this.codeFontFamily,
    );
  }
}
