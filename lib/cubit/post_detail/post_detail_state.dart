part of 'post_detail_cubit.dart';

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState.initial() = _Initial;
  const factory PostDetailState.loaded(PostDetail posts) = _Loaded;
  const factory PostDetailState.failed(String error) = Error;
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
