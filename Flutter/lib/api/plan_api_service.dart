
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/planmodel.dart';

part 'plan_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:5000/api/plans")
abstract class PlanApiService {
  factory PlanApiService(Dio dio, {String baseUrl}) = _PlanApiService;

  @GET("/")
  Future<List<PlanModel>> getPlans();

  @POST("/create")
  Future<PlanModel> addPlan(
      @Header("Authorization") String authorization, @Body() PlanModel plan);

  @POST("/edit")
  Future<PlanModel> updatePlan(
      @Header("Authorization") String authorization, @Body() PlanModel plan);

  @DELETE("/delete/{id}")
  Future<void> removePlan(
      @Header("Authorization") String authorization, @Path("id") String id);
}
