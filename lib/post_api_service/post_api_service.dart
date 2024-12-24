import 'package:dio/dio.dart';
import 'package:irohasu_blog/post.dart';
import 'package:irohasu_blog/post_api_service/api_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'list_posts.dart';

part 'post_api_service.g.dart';

@RestApi(baseUrl: 'https://api.irohasu.moe/')
abstract class ApiService {
  factory ApiService(Dio dio) {
    return _ApiService(dio);
  }

  factory ApiService.create() => ApiService(Dio()
    ..interceptors.addAll([
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90)
    ]));

  @GET('/api/posts')
  Future<ListPosts> getGist();

  @GET('/api/posts/{id}')
  Future<ApiResult<Post>> getContent(@Path('id') String id);
}
