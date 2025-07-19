import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/fetchplanmodel.dart';
import '../models/fetchpostsmodel.dart';
import '../models/planmodel.dart';
import '../models/postmodel.dart';

part 'social_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:5000/api/social")
abstract class SocialApiService {
  factory SocialApiService(Dio dio, {String baseUrl}) = _SocialApiService;

// Uncomment and implement other methods as needed

  @GET("/")
  Future<List<FetchPlanModel>> getSharedPlans(
      @Header("Authorization") String authorization);

  @GET("/rate/up/{id}")
  Future<void> like(
      @Header("Authorization") String authorization, @Path("id") String id);

  @GET("/rate/down/{id}")
  Future<void> dislike(
      @Header("Authorization") String authorization, @Path("id") String id);

  @GET("/post")
  Future<List<FetchPostModel>> getPosts(
      @Header("Authorization") String authorization);

  @POST("/post")
  Future<String> createPost(
      @Header("Authorization") String authorization, @Body() PostModel post);

  @DELETE("/post/delete/{id}")
  Future<void> deletePost(
      @Header("Authorization") String authorization, @Path("id") String id);

  @GET("/share/{id}")
  Future<void> sharePlan(
      @Header("Authorization") String authorization, @Path("id") String id);

  @GET("/share/add/{id}")
  Future<void> addSharedPlan(
      @Header("Authorization") String authorization, @Path("id") String id);
}
