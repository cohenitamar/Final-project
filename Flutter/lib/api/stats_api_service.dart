
import 'package:IOFit/models/poststatsmodel.dart';
import 'package:IOFit/models/statsmodel.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/achievementmodel.dart';



part 'stats_api_service.g.dart';


@RestApi(baseUrl: "http://10.0.2.2:5000/api/stats")
abstract class StatsApiService {
  factory StatsApiService(Dio dio, {String baseUrl}) = _StatsApiService;

  @GET("/")
  Future<StatsModel> getStats();


  @POST("/")
  Future<void> addStats(@Header("Authorization") String authorization,
      @Body() PostStatsModel postStatsModel);

  @POST("/achievement")
  Future<void> updateAchievement(@Header("Authorization") String authorization,
      @Body() AchievementModel achievementModel);






  /*






  @PUT("/{id}")
  Future<User> updateUser(@Path("id") String id, @Body() User user);

  @DELETE("/{id}")
  Future<void> deleteUser(@Path("id") String id);

  @GET("/{id}")
  Future<User> getUserByID(@Path("id") String id);
  */
}