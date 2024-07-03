import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResult<T> {
  final T data;
  @JsonKey(defaultValue: '')
  final String? error;

  const ApiResult({required this.data, this.error});

  factory ApiResult.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResultFromJson(json, fromJsonT);

  @override
  String toString() => 'ApiResult(data: $data, error: $error)';
}
