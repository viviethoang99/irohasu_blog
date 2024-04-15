import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../post_detail.dart';
import 'gist.dart';

part 'post_api_service.g.dart';

@RestApi(baseUrl: 'https://api.github.com')
abstract class GistClient {
  factory GistClient(Dio dio, {String baseUrl}) = _GistClient;

  @GET('/users/viviethoang99/gists')
  Future<List<Gist>> getGist();

  @GET('/gists/{id}')
  Future<PostDetail> getContent(@Path('id') String id);
}
