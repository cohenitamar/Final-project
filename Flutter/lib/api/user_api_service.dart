// lib/api/user_api_service.dart

import 'package:IOFit/User/PersonalInformation.dart';
import 'package:IOFit/models/usermodel.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/personalinformationmodel.dart';
import '../models/registerusermodel.dart';
import '../models/userbyidmodel.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:5000/api/user")
abstract class UserApiService {
  factory UserApiService(Dio dio, {String baseUrl}) = _UserApiService;

  @GET("/")
  Future<UserModel> getUser(@Header("Authorization") String authorization);

  @POST("/create")
  Future<void> createUser(@Header("Authorization") String authorization,
  @Body() RegisterUserModel user);

  @GET("/{id}")
  Future<UserByIDModel> getUserByID(@Path("id") String id);

  @POST("/")
  Future<void> updateUser(@Header("Authorization") String authorization,
      @Body() PersonalInformationModel info);

}
